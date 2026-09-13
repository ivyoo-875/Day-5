from http.server import BaseHTTPRequestHandler, HTTPServer

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        message = """
        <html>
        <body>
            <h1>Hello from Terraform EC2!</h1>
            <p>Application is running successfully.</p>
            <p>Deployed using Terraform provisioners.</p>
        </body>
        </html>
        """

        self.wfile.write(message.encode())

server = HTTPServer(("0.0.0.0", 80), MyHandler)

print("Web server started on port 80")

server.serve_forever()