import pytest
from app import app as flask_app
from app import time_keeper as flask_time_keeper


@pytest.fixture()
def app():
    yield flask_app


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def runner(app):
    return app.test_cli_runner()


@pytest.fixture()
def time_keeper():
    yield flask_time_keeper
