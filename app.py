from flask import Flask, render_template, request, redirect, url_for, session
from flask_wtf import CSRFProtect
import boto3
from boto3.dynamodb.conditions import Attr
import os
import uuid
import logging
from prometheus_flask_exporter import PrometheusMetrics


# =========================
# Flask App
# =========================
app = Flask(__name__)

# =========================
# Prometheus Metrics
# =========================
metrics = PrometheusMetrics(app, group_by='endpoint')

# =========================
# Logging
# =========================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# =========================
# Secret key
# =========================
app.secret_key = os.getenv("FLASK_SECRET_KEY")

if not app.secret_key:
    raise RuntimeError("FLASK_SECRET_KEY not set")

csrf = CSRFProtect(app)

# =========================
# DynamoDB connection
# =========================
dynamodb = boto3.resource(
    "dynamodb",
    region_name=os.getenv("AWS_DEFAULT_REGION", "ap-southeast-1")
)

users_table = dynamodb.Table("Users")
sales_table = dynamodb.Table("SalesTable")


# =========================
# Health check (ALB)
# =========================
@app.route("/health")
def health():
    return {'status': 'healthy'}, 200


# =========================
# Register User
# =========================
@app.route("/register", methods=["GET", "POST"])
def register():

    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")

        existing = users_table.get_item(Key={"username": username})

        if "Item" in existing:
            return render_template("register.html", error="User already exists")

        users_table.put_item(
            Item={
                "username": username,
                "password": password,
                "role": "user"
            }
        )

        logger.info(f"User registered: {username}")

        return redirect(url_for("login"))

    return render_template("register.html")


# =========================
# Login
# =========================
@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")

        response = users_table.get_item(Key={"username": username})
        user = response.get("Item")

        if user and user["password"] == password:

            session["user"] = username
            session["role"] = user.get("role", "user")

            logger.info(f"User logged in: {username}")

            return redirect(url_for("index"))

        return render_template("login.html", error="Invalid credentials")

    return render_template("login.html")


# =========================
# Main Sales Page
# =========================
@app.route("/")
@app.route("/index")
def index():

    if "user" not in session:
        return redirect(url_for("login"))

    return render_template("index.html")


# =========================
# Purchase
# =========================
@app.route("/purchase", methods=["POST"])
def purchase():

    if "user" not in session:
        return redirect(url_for("login"))

    product = request.form.get("product")
    amount = int(request.form.get("amount"))

    sale_id = str(uuid.uuid4())

    sales_table.put_item(
        Item={
            "sale_id": sale_id,
            "username": session["user"],
            "product": product,
            "amount": amount
        }
    )

    logger.info(f"Sale created: {sale_id}")

    return render_template(
        "index.html",
        success=True,
        amount=amount
    )


# =========================
# Dashboard
# =========================
@app.route("/dashboard")
def dashboard():

    if "user" not in session:
        return redirect(url_for("login"))

    role = session.get("role")

    if role == "admin":
        response = sales_table.scan()
    else:
        response = sales_table.scan(
            FilterExpression=Attr("username").eq(session["user"])
        )

    sales = response.get("Items", [])

    total_sales = len(sales)
    total_amount = sum(int(s["amount"]) for s in sales)

    return render_template(
        "dashboard.html",
        total_sales=total_sales,
        total_amount=total_amount,
        sales=sales
    )


# =========================
# Admin delete user
# =========================
@app.route("/admin/delete_user/<username>", methods=["POST"])
def delete_user(username):

    if session.get("role") != "admin":
        return "Not authorized", 403

    users_table.delete_item(Key={"username": username})

    logger.info(f"User deleted: {username}")

    return redirect(url_for("dashboard"))


# =========================
# Logout
# =========================
@app.route("/logout", methods=["POST"])
def logout():

    session.clear()

    return redirect(url_for("login"))


# =========================
# Run Flask
# =========================
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)