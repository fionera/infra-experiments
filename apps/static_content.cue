package apps

#StaticContent: {
	#App

	#in: {
		pvc: string
	}

	Deployment: "static-content": spec: template: spec: {
		containers: [{
			image: "httpd:2.4.54-alpine"
			name:  "httpd"
			ports: [{
				containerPort: 80
				name:          "http"
			}]
			volumeMounts: [{
				name:      "data"
				mountPath: "/usr/local/apache2/htdocs/"
			}]
		}]
		volumes: [{
			name: "data"
			persistentVolumeClaim: claimName: #in.pvc
		}]
	}

	Service: "static-content": spec: ports: [{
		name: "http"
		port: 80
	}]
}
