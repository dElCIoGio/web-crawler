from urllib.parse import urlparse, urlunparse

def normalize_url(url: str) -> str:
    parsed = urlparse(url)

    scheme = parsed.scheme or "https"
    host = parsed.netloc.lower()
    path = parsed.path or "/"

    return urlunparse((scheme, host, path, "", "", ""))

def get_domain(url: str) -> str:
    return urlparse(normalize_url(url)).netloc