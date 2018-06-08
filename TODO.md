# TO-DO

## 1. Static IP
### Why?
Because we need a hostname for the generated certificate, and I can't create the subdomain swarm.ourscienceistight.com 
until I have a static IP address I know wil always point to the swarm manager node.

### How?
This issue suggests that binding a Scaleway static IP to a new server instance is possible:

https://github.com/hashicorp/terraform/pull/14515

### Whats Next?
How do we go about this? Does Terraform create the initial static IP and then is "smart" about it after that, in that it
doesnt destroy it? Do we need to mark it as do not destroy? How does terraform know to pick THIS specific static IP when
rebuilding?

Answers to the above questions will determine how I move forward wit this.

### Desired Outcome
I have a static IP tat I can point the A record of swarm.ourscienceistight.com to. I can then hard code the hostname in 
the certificate generation scripts (temporarily at least, until I replace it with a variable passed to Terraform)

### Future Opportunities
This may mean that its possible to generate the various certificates using the Terraform TLS provider, rather than by 
Make; maybe only generating the CA and passing that as a variable to Terraform? This requires further elaboration and 
spiking.

## 2. Layered structure to Terraform files
### Why?
The repo is becoming a bit of a mess, as I've been trying to maintain the original project structure used in the 
original fork. Breaking everything into infrastructure layers via modules might result in a simpler structure and 
provide me the opportunity to isolate change to a layer, and redeploy only that layer.

### How?
At this point it is probably best to create a new Github repo and build the project from scratch with the correct 
structure rather than maintaining this fork.

Examples of possible infrastructure layers:
  1. Network
  2. Certs
  3. Security
  4. Servers
  
### Whats Next?
Start the rebuild in the new repo.

### Desired Outcome
I should be able to make quick changes to each layer knowing that change will only affect the current layer and above 
due to isolation.

### Future Opportunities
I may be able to eventually get to a point where the top layer is service deployment.
