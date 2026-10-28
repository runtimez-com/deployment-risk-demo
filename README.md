# deployment-risk-demo

A small Helm chart used to demonstrate the [runtimez deployment-risk gate](https://github.com/runtimez-com/deployment-risk-action) on real pull requests. Nothing here runs in production.

- `chart/`: the demo app: Deployment `web`, its Service, Ingress (TLS), PodDisruptionBudget, NetworkPolicies, and a postgres StatefulSet.
- `values.yaml`: the values `main` ships. Each demo PR changes a few lines of it.
- `.github/workflows/pr-gate.yml`: renders the chart for the PR head and the base branch and runs the gate on both, so it can compare them.

## The demo PRs

| Branch | The change | What the gate should say |
|---|---|---|
| `clean-bump` | web image 1.4.2 → 1.4.3 | passes |
| `cut-costs` | web to 1 replica, readiness probe off, memory limit 512Mi → 256Mi | blocks: the PDB now stops every node drain |
| `traffic` | Service to LoadBalancer with a selector that matches nothing, Ingress TLS off | blocks |
| `scaling` | PDB and topology spread removed | passes at `fail-on: HIGH`, with warnings |
| `data` | postgres 15 → 16, volume 10Gi → 20Gi | blocks |

The "Cut costs" report is written up at <https://runtimez.io/sample-pr-report>.

Render it yourself:

```sh
helm template web ./chart -f values.yaml
```
