import json
import argparse
from jwcrypto import jwk

# Set up command-line argument parsing
parser = argparse.ArgumentParser(description="Extract a JWK by kid and export it to PEM.")
parser.add_argument("-k", "--kid", required=True, help="The Key ID (kid) to search for in the JWKS")
parser.add_argument("--jwks", default="jwks.json", help="Path to the JWKS file (default: jwks.json)")
args = parser.parse_args()

# Load JWKS
with open(args.jwks) as f:
    keys = json.load(f)['keys']

# Find the key with the specified kid
try:
    jwk_key = next(k for k in keys if k['kid'] == args.kid)
except StopIteration:
    print(f"No key found with kid: {args.kid}")
    exit(1)

# Create and export the key
key = jwk.JWK(**jwk_key)
print(key.export_to_pem().decode())

