--- @class vim.lsp.Config
return {
	cmd = {
		"yaml-language-server",
		"--stdio",
	},
	filetypes = {
		"yaml",
		"yaml.docker-compose",
		"yaml.gitlab",
	},
	settings = {
		yaml = {
			kubernetesCRDStore = {
				enable = true,
			},
			schemas = {
				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "api.yaml",
				["https://json.schemastore.org/sqlc-2.0.json"] = "sqlc.yaml",
				-- We keep deploy/applications/ out of the kubernetes glob, those files are ArgoCD Application resources, not core Kubernetes.
				kubernetes = {
					"**/manifest/*.yaml",
					"**/deploy/chariot/**/*.yaml",
					"**/ops/config/**/*.yaml",
					"**/ops/k8s/**/argocd/*.yaml",
					"**/ops/k8s/**/trino/*.yaml",
					"**/ops/k8s/**/storage/**/*.yaml",
				},
				-- The https://github.com/datreeio/CRDs-catalog is a community-maintained repository of JSON schemas for popular CRDs.
				["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "**/deploy/applications/**/*.yaml",
				["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/karpenter.sh/nodepool_v1.json"] = "**/karpenter/*nodepool*.yaml",
				["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/eks.amazonaws.com/nodeclass_v1.json"] = "**/karpenter/*nodeclass*.yaml",
			},
		},
	},
}
