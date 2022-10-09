package apps

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

_AppsV1Schema: V={
	// set the matchLabels to the app labels
	spec: selector: matchLabels: V.metadata.labels

	// set the template labels to the matchLabels since these two have to be the same
	spec: template: metadata: labels: V.spec.selector.matchLabels

	// set the template annotations to the app annotations
	spec: template: metadata: annotations?: V.metadata.annotations
}

#App: A={
	#appName:   string
	#namespace: string
	[KIND=string]: [NAME=string]: {
		kind: KIND
		metadata: namespace: #namespace
		metadata: name:      NAME
		metadata: labels: {
			"app.kubernetes.io/name":      NAME
			"app.kubernetes.io/instance":  #appName
			"app.kubernetes.io/component": string | *#appName
		}
	}
	#out: {
		for k, v in A if k != "#in" && k != "#out" {
			"\(k)": v
		}
	}

	Secret: [NAME=string]: corev1.#Secret & {
		apiVersion: "v1"
	}
	DaemonSet: [NAME=string]: appsv1.#DaemonSet & _AppsV1Schema & {
		apiVersion: "apps/v1"
	}
	Deployment: [NAME=string]: appsv1.#Deployment & _AppsV1Schema & {
		apiVersion: "apps/v1"
	}
	StatefulSet: [NAME=string]: appsv1.#StatefulSet & _AppsV1Schema & {
		apiVersion: "apps/v1"
	}
	Service: [NAME=string]: corev1.#Service & {
		apiVersion: "v1"
		spec: {
			selector: [string]: string

			if Deployment[NAME] != _|_ {
				selector: Deployment[NAME].spec.selector.matchLabels
			}

			if StatefulSet[NAME] != _|_ {
				selector: StatefulSet[NAME].spec.selector.matchLabels
			}
		}
	}

	PersistentVolumeClaim: [NAME=string]: corev1.#PersistentVolumeClaim & {
		apiVersion: "v1"
		spec: accessModes: [
			"ReadWriteOnce",
		]
	}

	ConfigMap: [NAME=string]: corev1.#ConfigMap & {apiVersion: "v1"}

	Application: [NAME=string]: {...} & {apiVersion: "argoproj.io/v1alpha1"}
}
