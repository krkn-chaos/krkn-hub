## CI Tests

### First steps
Edit [all_tests](tests/all_tests) with tests you want to run 

### How to run 
```./CI/run.sh``` 

This will run docker commands so make sure docker is set up and configured properly

If you want to run using podman you'll need to edit each of the tests to use the podman command

As well as take out the service type on the build line so it will looks like the below

```podman-compose build (builds all images in docker-compose file)```


Since you'll create all images you want to get the specific image that matches your test add the following line

 ```image_id=$($command images --all | grep application-outages | head -n 1 | awk '{print $3}' )```


### Secret parameters

If you want to add a variable that should be kept secret

1. Go to settings
2. Go to secrets
3. Update or Add new repository secret
4. Add env variable in the form of ${{ secrets.<variable name> }} to your step you need to use it


### GitHub Actions Information

GitHub Actions does not allow forked repos to run the upstream CI with secrets in the main repository. 

You'll have to edit the .github/workflows/main.yml file to run on a push to your branch name


Edit line 4 with your branch name 
 
Make sure your secrets are all set up:
* OPENSHIFT_SERVER
* OPENSHIFT_USER
* OPENSHIFT_PASSWORD
* QUAY_USER
* QUAY_TOKEN
* VPC_ID
* SUBNET_ID
* AWS_ACCESS_KEY_ID
* AWS_SECRET_ACCESS_KEY 


