package testing

import (
	"encoding/yaml"
	"tool/cli"
	"tool/os"
	"tool/exec"
	"strings"

	"git.ctdo.de/ctdo-admins/infra/apps"
)

appFlag: *null | string @tag(app)

objects: [
	for appName, appObjects in instances
	if (appFlag == null && appName != "infra") || appName == appFlag
	for kind, objs in appObjects
	for name, obj in objs {
		obj
	},
]

argoApps: [ for a, _ in instances if a != "infra" {
	apps.#ArgoApplication & {
		#appName:   a
		#namespace: "argocd"
		#in: {
			appName:      "\(a)"
			appNamespace: "argocd"
			source:       instances.infra.#in.source
		}
	}
}]

argoObjects: [
	for appName, appObjects in argoApps
	for kind, objs in appObjects
	for name, obj in objs {
		obj
	},
]

command: dump: dump: cli.Print & {
	text: yaml.MarshalStream(objects)
}

command: apps: dump: cli.Print & {
	text: strings.Join([ for n, _ in instances {n}], "\n")
}

command: argo_apps: dump: cli.Print & {
	text: yaml.MarshalStream(argoObjects)
}

command: argo: {
	env: os.Getenv & {
		ARGOCD_ENV_CMD: string
	}

	run: exec.Run & {
		$after: env
		cmd:    ["cue"] + strings.Split(env["ARGOCD_ENV_CMD"], " ")
	}
}
