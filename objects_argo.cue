package testing

import "git.ctdo.de/ctdo-admins/infra/apps"

instances: "infra": apps.#ArgoApplication & {
	#namespace: "argocd"
	#in: {
		appName:      "infra"
		appNamespace: "argocd"
		source: {
			repoURL: "git@git.ctdo.de:ctdo-admin/infra.git"
		}
		cmd: "argo_apps"
	}

	ConfigMap: "argocd-ssh-known-hosts-cm": {
		data: ssh_known_hosts: """
			git.ctdo.de ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwHsqRboyr+I5ff6hEO/A1VlmuObjwboRQcX8JECtZW
			git.ctdo.de ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAy0a3oinYU6RW7KWKmxg5iH5YDli3cUdDo8bZMsInUSt0Aeu8BHrS+RZMbVNdt0Gu5NNl4/P1q/11xs0EsORLA=
			git.ctdo.de ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcqzGB5o8muM4wi/uLT0sugRdF6JyOUSinfRZ9UXLUYPos25bp0RHQFQiY0sZl8qeeMzaeOHNTMk6DgVDTIyYAKNZjYddfPZpaQUR5hKdGtc1tXF0c5NR+DU786LwHpuyWX+hDXespmeBo+ywkLtkRZ0sq+AK05z5hGjoqGKFyAs9xc7u48Mi+3plffHcvkbf8NoNU0hf2pyaWpwDoLyk6fo1ctwQGsgO7mxDIdGW1fBg/Fl+6N8uzKfEmTG9vN4UI2rmPu7W+AU1P8gQ8qDwdJtuPcA3+qJ325zxtd8vXgTbKPVtfWWp9YvOSp1HWk3IziSGNiFSuxZx5LA7+8XRt
			"""
	}

	Secret: infra: {
		metadata: {
			labels: "argocd.argoproj.io/secret-type": "repository"
		}
		stringData: {
			type: "git"
			url:  #in.source.repoURL
			sshPrivateKey: """
				-----BEGIN OPENSSH PRIVATE KEY-----
				-----END OPENSSH PRIVATE KEY-----
				"""
		}
	}
}
