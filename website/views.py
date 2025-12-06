from flask import Blueprint, render_template, request
import pymysql
 

bp = Blueprint("main", __name__, template_folder="templates", static_folder="static")


@bp.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        username = request.form.get("username", "")
        password = request.form.get("password", "")
        query = f"SELECT * FROM users WHERE username='{username}' AND password='{password}'"
        conn = pymysql.connect(
             host='127.0.0.1',
             user='',
             password='',
             database=''
            )
        cursor = conn.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
        return render_template("main.html", username=username, password=password, result=result)
    return render_template("main.html")

