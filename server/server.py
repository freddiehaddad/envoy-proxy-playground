from flask import Flask

app = Flask(__name__)
app.url_map.strict_slashes = False

redirect_count = 0

@app.route('/')
def root():
    global redirect_count
    redirect_count += 1
    return f'envoy redirects to server container: {redirect_count}\n'
