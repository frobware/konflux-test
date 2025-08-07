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

package controller

import (
	"context"

	"k8s.io/apimachinery/pkg/runtime"
	ctrl "sigs.k8s.io/controller-runtime"
	"sigs.k8s.io/controller-runtime/pkg/client"
	"sigs.k8s.io/controller-runtime/pkg/log"

	catalogv1 "github.com/frobware/konflux-test/api/v1"
)

// TestBundleReconciler reconciles a TestBundle object
type TestBundleReconciler struct {
	client.Client
	Scheme *runtime.Scheme
}

// +kubebuilder:rbac:groups=catalog.konflux.example.com,resources=testbundles,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=catalog.konflux.example.com,resources=testbundles/status,verbs=get;update;patch
// +kubebuilder:rbac:groups=catalog.konflux.example.com,resources=testbundles/finalizers,verbs=update

// Reconcile is part of the main kubernetes reconciliation loop which aims to
// move the current state of the cluster closer to the desired state.
// TODO(user): Modify the Reconcile function to compare the state specified by
// the TestBundle object against the actual cluster state, and then
// perform operations to make the cluster state reflect the state specified by
// the user.
//
// For more details, check Reconcile and its Result here:
// - https://pkg.go.dev/sigs.k8s.io/controller-runtime@v0.20.2/pkg/reconcile
func (r *TestBundleReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
	logger := log.FromContext(ctx)

	// Fetch the TestBundle instance
	var bundle catalogv1.TestBundle
	if err := r.Get(ctx, req.NamespacedName, &bundle); err != nil {
		logger.Error(err, "unable to fetch TestBundle")
		return ctrl.Result{}, client.IgnoreNotFound(err)
	}

	logger.Info("Reconciling TestBundle", "name", bundle.Name, "operatorImage", bundle.Spec.OperatorImage)

	// Update status to show we're processing
	bundle.Status.Phase = "Ready"
	bundle.Status.ObservedGeneration = bundle.Generation

	if err := r.Status().Update(ctx, &bundle); err != nil {
		logger.Error(err, "unable to update TestBundle status")
		return ctrl.Result{}, err
	}

	logger.Info("TestBundle reconciliation complete", "operatorImage", bundle.Spec.OperatorImage, "bundleImage", bundle.Spec.BundleImage)
	return ctrl.Result{}, nil
}

// SetupWithManager sets up the controller with the Manager.
func (r *TestBundleReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&catalogv1.TestBundle{}).
		Named("testbundle").
		Complete(r)
}
