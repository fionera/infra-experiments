// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/crunchydata/postgres-operator/pkg/apis/postgres-operator.crunchydata.com/v1beta1

package v1beta1

// PostgreSQL identifiers are limited in length but may contain any character.
// More info: https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-IDENTIFIERS
//
// +kubebuilder:validation:MinLength=1
// +kubebuilder:validation:MaxLength=63
#PostgresIdentifier: string

#PostgresPasswordSpec: {
	// Type of password to generate. Defaults to ASCII. Valid options are ASCII
	// and AlphaNumeric.
	// "ASCII" passwords contain letters, numbers, and symbols from the US-ASCII character set.
	// "AlphaNumeric" passwords contain letters and numbers from the US-ASCII character set.
	// +kubebuilder:default=ASCII
	// +kubebuilder:validation:Enum={ASCII,AlphaNumeric}
	type: string @go(Type)
}

#PostgresPasswordTypeAlphaNumeric: "AlphaNumeric"
#PostgresPasswordTypeASCII:        "ASCII"

#PostgresUserSpec: {
	// The name of this PostgreSQL user. The value may contain only lowercase
	// letters, numbers, and hyphen so that it fits into Kubernetes metadata.
	// +kubebuilder:validation:Pattern=`^[a-z0-9]([-a-z0-9]*[a-z0-9])?$`
	// +kubebuilder:validation:Type=string
	name: #PostgresIdentifier @go(Name)

	// Databases to which this user can connect and create objects. Removing a
	// database from this list does NOT revoke access. This field is ignored for
	// the "postgres" user.
	// +listType=set
	// +optional
	databases?: [...#PostgresIdentifier] @go(Databases,[]PostgresIdentifier)

	// ALTER ROLE options except for PASSWORD. This field is ignored for the
	// "postgres" user.
	// More info: https://www.postgresql.org/docs/current/role-attributes.html
	// +kubebuilder:validation:Pattern=`^[^;]*$`
	// +optional
	options?: string @go(Options)

	// Properties of the password generated for this user.
	// +optional
	password?: null | #PostgresPasswordSpec @go(Password,*PostgresPasswordSpec)
}
