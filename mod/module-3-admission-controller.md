# Module 3 - Calico Cloud Admission Controller

1. Upgrade the OpenSSL from 1.0 to 1.1 (if needed in your environment)

   ```bash
   sudo yum -y update
   sudo yum install -y make gcc perl-core pcre-devel wget zlib-devel
   wget https://ftp.openssl.org/source/openssl-1.1.1k.tar.gz
   sudo tar -xzvf openssl-1.1.1k.tar.gz
   cd openssl-1.1.1k
   sudo ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic
   sudo make
   sudo make install
   openssl version && cd ..
   ```

2. Configure the Admission Controller.

   Calico Cloud uses the Admission Controller to accept or reject resources that create pods based on configured ContainerAdmissionPolicies    rules. For more information refer to Calico Cloud Admission Controller documentation.

   Configure the Admission Controller.

   Instructions for **Linux**:

   ```bash
   # Create workdir
   mkdir admission-controller-install && cd admission-controller-install
   # Generate certs
   export URL="https://installer.calicocloud.io/manifests/v3.16.1-11/manifests" && curl ${URL}/generate-open-ssl-key-cert-pair.sh | bash
   # Generate admission controller manifests
   export URL="https://installer.calicocloud.io/manifests/v3.16.1-11/manifests" && \
   export IN_NAMESPACE_SELECTOR_KEY="apply-container-policies" && \
   export IN_NAMESPACE_SELECTOR_VALUES="true" && \
   curl ${URL}/install-ia-admission-controller.sh | bash
   # Install admission controller
   kubectl apply -f ./tigera-image-assurance-admission-controller-deploy.yaml && cd ..
   ```

   Instructions for **MacOS**:

   ```bash
   # Create workdir
   mkdir admission-controller-install && cd admission-controller-install
   # Generate certs
   export URL="https://installer.calicocloud.io/manifests/v3.16.1-11/manifests" && curl ${URL}/generate-open-ssl-key-cert-pair.sh | bash
   # Generate admission controller manifests
   export URL="https://installer.calicocloud.io/manifests/v3.16.1-11/manifests" && \
   export IN_NAMESPACE_SELECTOR_KEY="apply-container-policies" && \
   export IN_NAMESPACE_SELECTOR_VALUES="true" && \
   bash install-ia-admission-controller-macos.sh
   # Install admission controller
   kubectl apply -f ./tigera-image-assurance-admission-controller-deploy.yaml && cd ..
   ```

   > The Admission Controller only watches the namespaces it is configured to track. You can configure namespace label via    `IN_NAMESPACE_SELECTOR_KEY` and `IN_NAMESPACE_SELECTOR_VALUES` variables used in the commands above. Explore    `tigera-image-assurance-admission-controller-deploy.yaml` manifest to see how those values are configured.

3. Configure container admission policies.

   The ContainerAdmissionPolicies resources are used to configure policies for Admission Controller.

   Deploy container policy.

   ```yaml
   kubectl create -f - <<-EOF
   apiVersion: containersecurity.tigera.io/v1beta1
   kind: ContainerAdmissionPolicy
   metadata:
     name: reject-failed-and-non-dockerhub
   spec:
     selector: all()
     namespaceSelector: "apply-container-policies == 'true'"
     order: 10
     rules:
     - action: Allow
       imagePath:
         operator: IsOneOf
         values:
         - "^registry.hub.docker.com/.*"
       imageScanStatus:
         operator: IsOneOf
         values:
         - Pass
         - Warn
       imageLastScan:
         operator: "gt"
         duration:
           days: 7
     - action: Reject
   EOF
   ```

4. Create the namespace `website` adding the label to allow the Admission Controller to watch it.

   ```bash
   kubectl create namespace website
   kubectl label namespace website apply-container-policies=true
   ```

5. Deploy the application to test the enviroment.

   ```bash
   kubectl create -f manifests/website.yaml
   ```

   The deployment will fail to be created. The result will be similar to the below

   <pre>
   $ kubectl create -f manifests/website.yaml
   service/website created
   Error from server (Action 'Reject' enforced by ContainerPolicy reject-failed-and-non-dockerhub rule index 1):
   error when creating "./manifests/website.yaml": admission webhook "image-assurance.tigera.io" denied the request:
   Action 'Reject' enforced by ContainerPolicy reject-failed-and-non-dockerhub rule index 1
   </pre>

6. Create the exceptions in the Calico Cloud UI.

   The deployment will not be allowed to be created because the image failed to the scanning process.
   When this happen ideally you should fix the vulneabilities in the image before trying to deploy it again. However we know that this can be a slow and cumbersome process. As a workaround after evaluation the impact of the detected vulnerabilities, you may decide to create **exceptions** for the CVE's in the image, changing its status from `Fail` to `Warn`.

   ![exception](https://user-images.githubusercontent.com/104035488/207643561-ed2eec90-03a8-4fc7-a085-c845121fd21a.gif)

7. Try to create the deployment again

   ```bash
   kubectl apply -f manifests/website.yaml
   ```

   The image is accepted.

   <pre>
   deployment.apps/website created
   service/website unchanged
   </pre>

   Verify if the pods are running

   ```bash
   kubectl get pods -n website
   ```
   
   --- 

[:arrow_right: Module 4 - Implement zero-trust access controls and micro-segmentation](/mod/module-4-security-guardrails.md ) <br>

[:arrow_left: Module 2 - Scan Container Images](/mod/module-2-scan-images.md)

[:leftwards_arrow_with_hook: Back to Main](../README.md)