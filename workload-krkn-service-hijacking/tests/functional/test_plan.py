import json
import time

from app import method_steps, time_keeper


def test_plan_get_list_index(app, client, time_keeper):
    time_keeper.set_time()
    result = client.get("/list/index.php")
    assert result.mimetype == "application/json"
    assert result.status_code == 500
    expected = {"status": "internal server error"}
    assert expected == json.loads(result.get_data(as_text=True))
    time.sleep(5)
    result = client.get("/list/index.php")
    assert result.mimetype == "application/json"
    assert result.status_code == 201
    expected = {"status": "resource created"}
    assert expected == json.loads(result.get_data(as_text=True))


def test_plan_uses_cumulative_step_durations(client, monkeypatch):
    steps = [
        {"duration": 5, "status": 500, "mime_type": "text/plain", "payload": "first"},
        {"duration": 5, "status": 201, "mime_type": "text/plain", "payload": "second"},
        {"duration": 5, "status": 202, "mime_type": "text/plain", "payload": "third"},
    ]
    monkeypatch.setitem(method_steps, ("GET", "/list/index.php"), steps)
    monkeypatch.setattr(time, "time", lambda: 0)
    time_keeper.start_time = 0
    monkeypatch.setattr(time, "time", lambda: 6)

    result = client.get("/list/index.php")

    assert result.status_code == 201
    assert result.get_data(as_text=True) == "second"


def test_plan_without_payload_returns_validation_error(client, monkeypatch):
    steps = [{"duration": 5, "status": 500, "mime_type": "text/plain"}]
    monkeypatch.setitem(method_steps, ("GET", "/list/index.php"), steps)

    result = client.get("/list/index.php")

    assert result.status_code == 500
    assert '"payload"' in result.get_data(as_text=True)


def test_plan_post_list_index(app, client, time_keeper):
    time_keeper.set_time()
    result = client.post("/list/index.php")
    assert result.status_code == 401
    assert result.mimetype == "application/json"
    expected = {"status": "unauthorized"}
    assert expected == json.loads(result.get_data(as_text=True))
    time.sleep(7)
    result = client.post("/list/index.php")
    assert result.mimetype == "text/plain"
    assert result.status_code == 404
    expected = "not found"
    assert expected == result.get_data(as_text=True)


def test_plan_patch(app, client, time_keeper):
    time_keeper.set_time()
    result = client.patch("/patch/1?test=plan")
    assert result.status_code == 201
    assert result.mimetype == "text/plain"
    expected = "resource patched"
    assert expected == result.get_data(as_text=True)
    time.sleep(3)
    result = client.patch("/patch/2?test=next")
    assert result.mimetype == "text/plain"
    assert result.status_code == 400
    expected = "bad request"
    assert expected == result.get_data(as_text=True)
    time.sleep(2)
    result = client.patch("/patch/4?test=last")
    assert result.mimetype == "text/plain"
    assert result.status_code == 400
    expected = "bad request"
    assert expected == result.get_data(as_text=True)


def test_stats(app, client, time_keeper):
    time_keeper.set_time()
    get_resource = "/list/index.php?test=hook"
    post_resource = "/list/index.php?test=hook"
    patch_resource = "/patch/1?test=hook"
    client.get(get_resource)
    client.post(post_resource)
    client.patch(patch_resource)

    result = client.get("/krkn-stats")
    stats_json = json.loads(result.get_data(as_text=True))
    assert len(stats_json) == 3
    get = [r for r in stats_json if r["method"] == "GET"][0]
    post = [r for r in stats_json if r["method"] == "POST"][0]
    patch = [r for r in stats_json if r["method"] == "PATCH"][0]

    get_stat = [
        r for r in get["requests"] if get_resource in r["request_full_path"]
    ][0]
    post_stat = [
        r for r in post["requests"] if post_resource in r["request_full_path"]
    ][0]
    patch_stat = [
        r
        for r in patch["requests"]
        if patch_resource in r["request_full_path"]
    ][0]

    assert get_stat["mime_type"] == "application/json"
    assert get_stat["response_status_code"] == 500
    assert post_stat["mime_type"] == "application/json"
    assert post_stat["response_status_code"] == 401
    assert patch_stat["mime_type"] == "text/plain"
    assert patch_stat["response_status_code"] == 201
