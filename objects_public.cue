package testing

import "git.ctdo.de/ctdo-admins/infra/apps"

instances: [APP=string]: apps.#App & {
	#appName: APP
}

instances: "wordpress": {
	(apps.#Wordpress & {
		#namespace: "default"
		#in: {
			pvc: "wordpress"
			db: user:     "wordpress"
			db: password: "wordpress"
			db: name:     "wordpress"
			db: host:     "mysql"
		}
		PersistentVolumeClaim: "wordpress": spec: resources: requests: storage: "20Gi"
	}).#out

	(apps.#StaticContent & {
		#namespace: "default"
		#in: {
			pvc: "wordpress-static-content"
		}
		[string]: ["wordpress-static-content"]: metadata: labels: "app.kubernetes.io/component": "static-content"
		PersistentVolumeClaim: "wordpress-static-content": spec: resources: requests: storage: "20Gi"
	}).#out
}
