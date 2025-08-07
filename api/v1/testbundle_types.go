/*
Copyright 2025.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package v1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// EDIT THIS FILE!  THIS IS SCAFFOLDING FOR YOU TO OWN!
// NOTE: json tags are required.  Any new fields you add must have json tags for the fields to be serialized.

// TestBundleSpec defines the desired state of TestBundle.
type TestBundleSpec struct {
	// OperatorImage is the container image reference for the operator
	// This will be nudged when the operator component builds
	OperatorImage string `json:"operatorImage"`

	// BundleImage is the container image reference for the operator bundle
	// This will be nudged when the bundle component builds
	BundleImage string `json:"bundleImage,omitempty"`

	// Version represents the operator version
	Version string `json:"version,omitempty"`

	// Channel specifies the operator channel (e.g., "stable", "alpha")
	Channel string `json:"channel,omitempty"`
}

// TestBundleStatus defines the observed state of TestBundle.
type TestBundleStatus struct {
	// Phase represents the current phase of the bundle
	Phase string `json:"phase,omitempty"`

	// LastUpdated timestamp of the last successful update
	LastUpdated *metav1.Time `json:"lastUpdated,omitempty"`

	// ObservedGeneration reflects the generation observed by the controller
	ObservedGeneration int64 `json:"observedGeneration,omitempty"`

	// Conditions represent the current service state
	Conditions []metav1.Condition `json:"conditions,omitempty"`
}

// +kubebuilder:object:root=true
// +kubebuilder:subresource:status

// TestBundle is the Schema for the testbundles API.
type TestBundle struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   TestBundleSpec   `json:"spec,omitempty"`
	Status TestBundleStatus `json:"status,omitempty"`
}

// +kubebuilder:object:root=true

// TestBundleList contains a list of TestBundle.
type TestBundleList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []TestBundle `json:"items"`
}

func init() {
	SchemeBuilder.Register(&TestBundle{}, &TestBundleList{})
}
