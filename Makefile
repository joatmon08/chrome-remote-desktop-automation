gcp-bootstrap:
	(cd gcp-account && terraform init)
	(cd gcp-account && terraform apply)
	@(cd gcp-account && terraform output private_key_file | base64 -D | gpg --batch --pinentry-mode loopback --command-fd 0 --passphrase ${PASSPHRASE} -d -- | base64 -D > ../packer-builder.json)

packer-build:
	cd packer && packer build -var commit_hash=${COMMIT_HASH} desktop.json

unit:
	go test ./test/unit/... -v

test: clean
	(cd vagrant && vagrant up)

clean:
	(cd vagrant && vagrant destroy --force)

code-retrieve:
	open 'https://accounts.google.com/signin/oauth/oauthchooseaccount?client_id=440925447803-avn2sj1kc099s0r7v62je5s339mu0am1.apps.googleusercontent.com&as=9N0HAbxTh9EX3DeNmFH6nA&destination=https%3A%2F%2Fremotedesktop.google.com&approval_state=!ChR4cjNWU3MxaFZ6SENDR2RhcUtjSxIfc3lLbldNXzBBME1iVUU3MWpGWk5XazJUMVd5ZnVCWQ%E2%88%99AJDr988AAAAAXRI0hTY73KdyJvEZHTpUEUtc5Hp9pyFF&oauthgdpr=1&xsrfsig=ChkAeAh8T041ElTwoG6AjZ-q5N9JcdYzUEQiEg5hcHByb3ZhbF9zdGF0ZRILZGVzdGluYXRpb24SBXNvYWN1Eg9vYXV0aHJpc2t5c2NvcGU&flowName=GeneralOAuthFlow'
	
code-parse:
	echo '${URL}' | sed -e 's/.*code\=\(.*\)\&scope.*/\1/'

desktop-build:
	terraform apply

pages:
	(cd docs && npm run generate)