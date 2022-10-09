package apps

#Wordpress: {
	#App

	#in: {
		pvc: string
		db: {
			name:     string
			user:     string
			password: string
			host:     string
		}
	}

	Secret: wordpress: stringData: {
		WORDPRESS_DB_NAME:     #in.db.name
		WORDPRESS_DB_USER:     #in.db.user
		WORDPRESS_DB_PASSWORD: #in.db.password
		WORDPRESS_DB_HOST:     #in.db.host
	}

	Deployment: wordpress: spec: template: spec: {
		containers: [{
			image: "wordpress:6.0.2-php8.1-apache"
			name:  "wordpress"
			envFrom: [{secretRef: name: "wordpress"}]
			ports: [{
				containerPort: 80
				name:          "wordpress"
			}]
			volumeMounts: [{
				name:      "wordpress"
				mountPath: "/var/www/html"
			}]
		}]
		volumes: [{
			name: "wordpress"
			persistentVolumeClaim: claimName: #in.pvc
		}]
	}

	Service: wordpress: spec: ports: [{
		name: "http"
		port: 80
	}]
}
