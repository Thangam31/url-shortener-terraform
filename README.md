# Stage 3 — Terraform 3-Tier Architecture

Codified version of the Stage 2 hand-built 3-tier app, built entirely in Terraform modules.

## Architecture
- VPC `10.0.0.0/16` with 2 public, 2 app (private), 2 data (private) subnets across `ap-south-1a` and `ap-south-1b`
- Custom NAT instance (t3.micro) in a public subnet — Free Tier friendly (~$0.017/hr vs ~$32/mo for NAT Gateway)
- ALB (public) → target group (port 80, health check `/health`) → ASG (min 1, max 2, desired 1) in private app subnets
- App instances run nginx via user_data, serving `{"status":"ok"}` on `/health`

## Modules
- `modules/vpc` — VPC, subnets, IGW, NAT instance, route tables
- `modules/alb` — ALB, target group, listener, ALB SG
- `modules/asg` — launch template, ASG, IAM instance profile, app SG

## Verified
- `terraform apply` → 29 resources created cleanly
- ASG instance: `Healthy` / `InService`
- `curl http://url-shortener-alb-585738911.ap-south-1.elb.amazonaws.com/health` → `HTTP/1.1 200 OK` `{"status":"ok"}`

## Troubleshooting log
1. **NAT instance MASQUERADE rule missing** → private instances had no outbound internet → ELB health checks failed → ASG replacement loop. Fixed by adding `iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE` and persisting it.
2. **Private route table pointed to wrong NAT instance** → traffic went to a NAT with no MASQUERADE rule. Fixed with `replace-route`.
3. **IAM permission maze** → `ec2:CreateVpc`, `ssm:GetParameter`, `iam:CreateRole`, `ssm:StartSession` all needed explicit grants on the deployer user.
4. **Target group port mismatch** → nginx listens on 80, target group checked 8080. Fixed by changing target group port to 80 and app SG ingress to 80.
5. **Terraform target group destroy blocked by listener** → had to delete the listener manually, then re-apply to let Terraform create the new listener pointing at the new target group.

## Cost notes (Free Tier)
- NAT Gateway replaced with a t3.micro NAT instance — saves ~$32/month
- EKS replaced with ECS (planned Stage 4) — saves ~$73/month
- `terraform destroy` after each session; `terraform apply` rebuilds in ~10 minutes
