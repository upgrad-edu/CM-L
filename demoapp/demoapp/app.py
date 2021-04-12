import random
import time
import logging
from flask import Flask ,url_for, render_template
from prometheus_flask_exporter import PrometheusMetrics
logging.basicConfig(filename='/logs/demo.log', level=logging.DEBUG)
app = Flask(__name__)

PrometheusMetrics(app)



@app.route('/')
def index():
    app.logger.info('Processing / request')
    return render_template('index.html')

@app.route('/ok')
def ok_route():
    return "OK!!"

@app.route('/slow')
def slow():
    time.sleep(random.randint(0,9))
    return "OK!!"
@app.route('/error')
def error_route():
    return "err",500


if __name__ == "__main__":
    app.run('0.0.0.0',5000,threaded=True)
