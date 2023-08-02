# Module 2 - Scan Container Images

## Environment Setup

1. Clone this repository in your Azure Cloud Shell.

   ```bash
   git clone https://github.com/tigera-solutions/cc-aks-strengthen-security-workshop.git && \
   cd cc-aks-strengthen-security-workshop
   ```

2. As it's not possible to run a container runtime engine on the Azure Cloud Shell. We will create a small virtual machine that will be used to demonstrate the tigera-scanner functionalities. For this, use the terraform in this repo:

   - Change directory to the terraform folder inside this repository.

     ```bash
     cd tfm
     ```

   - Run the following command to load the environment variables used during the AKS cluster creation.
     
     ```bash
     source ~/workshopvars.env
     ```
   - Map the terraform environment variables with the workshop variables.

     ```bash
     export TF_VAR_location=$LOCATION
     export TF_VAR_resource_group_name=$RESOURCE_GROUP
     echo $TF_VAR_location
     echo $TF_VAR_resource_group_name
     ```
   - Initialize the terraform in the folder.

     ```bash
     terraform init
     ```

   - Create the virtual machine
     
     ```bash
     terraform apply -auto-approve
     ```

   - Using the output command from the terrafom, ssh into the virtual machine.

     <pre>
     Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

     Outputs:

     ssh_command = "ssh -i ~/.ssh/id_rsa adminuser@20.63.41.254"
     </pre>

   - Scale the priviledge to root

     ```bash 
     sudo su - root
     ```

You are read for testing the tigera-scanner

## Pull the images to be scanned

Let's pull two images:

1. Pull the website image website:v1.0.0

   ```bash
   docker pull registry.hub.docker.com/regisftm/website:v1.0.0
   ```

2. Verify the downloaded image.

   ```bash
   docker images
   ```

## Scan the images

1. First, let's scan the images locally without exporting the results to Calico Cloud.

   ```bash
   tigera-scanner scan registry.hub.docker.com/regisftm/website:v1.0.0 | more
   ```
   
   This command will scan the image and present all the vulnerabilities found on it. However, as we didn't define the threshold for `PASS`, `WARN` or `FAIL` results, the reported `Scan result:` will be `UNKNOWN`.

   <pre>
   $ tigera-scanner scan registry.hub.docker.com/regisftm/website:v1.0.0 | more
   INFO[0000] Vulnerability database director not set, setting it to the cache default direct /home/ec2-user/.cache. 
   
    scanning registry.hub.docker.com/regisftm/website:v1.0.0... 
   
    Summary: 
   
    Name: registry.hub.docker.com/regisftm/website:v1.0.0
    Digest: 
    Number of dependencies: 42.
    Total vulnerabilities: 58, critical: 4, high: 26, medium: 26, low: 2, N/A: 0 
   
    Scan result:   UNKNOWN Please set fail_threshold(-f), warn_threshold(-w) for a scan result. 
   +------------+----------+----------------+------+--------------------------------+----------------------+------------------------------------------------------------------------------------------+
   | DEPENDENCY | SEVERITY |     CVE-ID     | CVSS |          DESCRIPTION           |      FIX RESULT      |                                        REFERENCES                                        |
   +------------+----------+----------------+------+--------------------------------+----------------------+------------------------------------------------------------------------------------------+
   | curl       | Critical | CVE-2022-32221 |  9.8 | When doing HTTP(S) transfers,  | fixed in [7.83.1-r4] | https://hackerone.com/reports/   1704017                                                 |
   |            |          |                |      | libcurl might erroneously      |                      |       
   ...
   [omitted output]
   </pre>

   Scan the image again, but now define the thresholds using --fail_threshold (or -f) and --warn_threshold (or -w)

   ```bash
   tigera-scanner scan registry.hub.docker.com/regisftm/website:v1.0.0 -f 7.9 -w 3.9 | more
   ```
   
   This time you will the the `Scan Result: FAIL`

2. Run the scan again, now exporting the result to the Calico Cloud.

   To export it to the Calico Cloud you will need to get the `apiurl` and `token` information from the Calico Cloud UI. Also check the `Enable Runtime View`.

   Go to Image Assurance > Scan Results > Settings  and copy the API URL and the API TOKEN
   
   ![apiurl](https://user-images.githubusercontent.com/104035488/207679431-02b5a56c-ca10-4fb6-b147-e881bf631cb7.gif)

   Export the values to enviroment variables:

   ```bash
   export APIURL=< paste the api url here! >
   ```

   ```bash
   export APITOKEN=< paste the api token here! >
   ```

   Run the `tigera-scanner` passing the `apiurl` and `token` parameters, so the result will be exported to Calico Cloud.

   ```bash
   tigera-scanner scan registry.hub.docker.com/regisftm/website:v1.0.0 --apiurl $APIURL --token $APITOKEN
   ```

   This is the expected output. 

   <pre>
   $ tigera-scanner scan registry.hub.docker.com/regisftm/website:v1.0.0 --apiurl $APIURL --token $APITOKEN
   INFO[0001] Vulnerability database director not set, setting it to the cache default direct /home/ec2-user/.cache. 
   
    scanning registry.hub.docker.com/regisftm/website:v1.0.0... 
   INFO[0001] Rebuilding dependencies with results from a previous scan of the image. 
   NOTE: Uploading results, this might take a while...
   NOTE: Uploaded vulnerability results for repository path / digest registry.hub.docker.com/regisftm/website:v1.0.   0@sha256:79a9e8505d68fb535fb0d3cfe33425b1876c2a52fb7d180d5f5de86ec2cdd557
   
    Summary: 
   
    Name: registry.hub.docker.com/regisftm/website:v1.0.0
    Digest: sha256:79a9e8505d68fb535fb0d3cfe33425b1876c2a52fb7d180d5f5de86ec2cdd557
    Number of dependencies: 42.
    Total vulnerabilities: 10, critical: 4, high: 6, medium: 0, low: 0, N/A: 0 
   
    Scan result:   ⚠ WARN (warn_threshold - 3.9, fail_threshold - 7.9, Using thresholds from Calico Cloud)  
    </pre>

     Now you can visualize the scan results in the Calico Cloud UI.

## Virtual Machine clean up

After the scan results were uploaded to Calico Cloud, we don't need the virtual machine anymore, so let's go ahead and destroy the terraform infrastructure.

```bash
terraform destroy -auto-approve
```

Return to the git cloned repository root directory:

```bash
cd ..
```

--- 

[:arrow_right: Module 3 - Calico Cloud Admission Controller](/mod/module-3-admission-controller.md) <br>

[:arrow_left: Module 1 - Connect your EKS cluster to Calico Cloud](/mod/module-1-connect-calicocloud.md)  
[:leftwards_arrow_with_hook: Back to Main](/README.md)  
