class HttpRequest:
    timestamp: float
    response_body: str
    response_status_code: int
    mime_type: str
    request_full_path: str

    def __init__(
        self,
        timestamp: float,
        response_body: str,
        response_status_code: int,
        mime_type: str,
        request_full_path: str,
    ):
        self.timestamp = timestamp
        self.response_body = response_body
        self.response_status_code = response_status_code
        self.mime_type = mime_type
        self.request_full_path = request_full_path

    def to_dict(self):
        return {
            "timestamp": self.timestamp,
            "response_body": self.response_body,
            "response_status_code": self.response_status_code,
            "mime_type": self.mime_type,
            "request_full_path": self.request_full_path,
        }


class Resource:
    resource: str
    method: str
    requests: list[HttpRequest]

    def __init__(self, resource: str, method: str):
        self.resource = resource
        self.method = method
        self.requests = list[HttpRequest]()

    def to_dict(self):
        return {
            "resource": self.resource,
            "method": self.method,
            "requests": [item.to_dict() for item in self.requests],
        }
