terraform_dir = ./file_notification_lambda

all:
	echo "deploy|destroy"
init:
	terraform -chdir=${terraform_dir} init
deploy:
	terraform -chdir=${terraform_dir} init
	yes yes | terraform -chdir=${terraform_dir} apply
destroy:
	yes yes | terraform -chdir=${terraform_dir} destroy
