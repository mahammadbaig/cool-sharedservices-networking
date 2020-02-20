#-------------------------------------------------------------------------------
# Create a private Route53 zone for the VPC.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_zone" {
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  name = var.cool_domain
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

#-------------------------------------------------------------------------------
# Create private Route53 reverse zones for the VPC subnets.
#-------------------------------------------------------------------------------
resource "aws_route53_zone" "private_subnet_private_reverse_zones" {
  count = length(var.private_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  # Note that this code assumes that we are using /24 blocks.
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 2),
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 1),
    element(split(".", var.private_subnet_cidr_blocks[count.index]), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}

resource "aws_route53_zone" "public_subnet_private_reverse_zones" {
  count = length(var.public_subnet_cidr_blocks)
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  # Note that this code assumes that we are using /24 blocks.
  name = format(
    "%s.%s.%s.in-addr.arpa.",
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 2),
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 1),
    element(split(".", var.public_subnet_cidr_blocks[count.index]), 0),
  )
  tags = var.tags
  vpc {
    vpc_id = aws_vpc.the_vpc.id
  }
}
