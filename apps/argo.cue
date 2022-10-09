package apps

#ArgoApplication: {
	#App
	#in: {
		appName:      string
		appNamespace: string
		source: {
			repoURL:        string
			targetRevision: string | *"HEAD"
			path:           string | *"."
			...
		}
		cmd: *"-t app=\(appName) dump" | string
	}

	Application: "\(#in.appName)": {
		spec: {
			project: "default"
			source:  #in.source
			source: plugin: env: [{
				name:  "CMD"
				value: #in.cmd
			}]
			destination: {
				server:    "https://kubernetes.default.svc"
				namespace: #in.appNamespace
			}
		}
	}
}
