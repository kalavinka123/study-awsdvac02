from flask import Flask, redirect, url_for, session
from authlib.integrations.flask_client import OAuth
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.secret_key = os.urandom(24)  # Use a secure random key in production
oauth = OAuth(app)

oauth.register(
  name='oidc',
  authority='https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_W3l9VoH31',
  client_id='41clihojld2n643kt1jbtan9jc',
  client_secret=os.environ.get("COGNITO_CLIENT_SECRET"),
  server_metadata_url='https://cognito-idp.ap-northeast-1.amazonaws.com/ap-northeast-1_W3l9VoH31/.well-known/openid-configuration',
  client_kwargs={'scope': 'email openid phone'}
)

@app.route('/')
def index():
    user = session.get('user')
    if user:
        return  f'Hello, {user["email"]}. <a href="/logout">Logout</a>'
    else:
        return f'Welcome! Please <a href="/login">Login</a>.'
    
@app.route('/login')
def login():
    # Alternate option to redirect to /authorize
    redirect_uri = url_for('authorize', _external=True)
    return oauth.oidc.authorize_redirect(redirect_uri)
    # return oauth.oidc.authorize_redirect('http://localhost:5000/authorize')

@app.route('/authorize')
def authorize():
    token = oauth.oidc.authorize_access_token()
    user = token['userinfo']
    session['user'] = user
    return redirect(url_for('index'))

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='localhost')