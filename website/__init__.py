from flask import Flask


def create_app():
	app = Flask(__name__, instance_relative_config=False)
	app.config.setdefault("SECRET_KEY", "dev")

	from .views import bp as main_bp
	app.register_blueprint(main_bp)

	return app

