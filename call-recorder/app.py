from flask import Flask, render_template, request, jsonify
import requests

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/send_request', methods=['POST'])
def send_request():
    param_value = request.form.get('param_value') + ';'
    
    url = 'http://10.1.15.11:8080/rpc'
    headers = {"Content-Type": "application/json"}
    data = {
        "jsonrpc": "2.0",
        "method": "cfg.sets",
        "params": ["parloa", "pcap_collector", param_value],
        "id": 1
    }
    
    response = requests.post(url, headers=headers, json=data)
    return jsonify(response.json())

if __name__ == '__main__':
    app.run(debug=True)

