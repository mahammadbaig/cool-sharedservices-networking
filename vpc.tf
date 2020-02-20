#-------------------------------------------------------------------------------
# Create the shared services VPC.
#-------------------------------------------------------------------------------
resource "aws_vpc" "the_vpc" {
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags                 = var.tags
}

#-------------------------------------------------------------------------------
# Set up external access and routing in the VPC.
#-------------------------------------------------------------------------------

# The internet gateway for the VPC
resource "aws_internet_gateway" "the_igw" {
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  vpc_id = aws_vpc.the_vpc.id
  tags   = var.tags
}

# Default route table
resource "aws_default_route_table" "the_route_table" {
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  default_route_table_id = aws_vpc.the_vpc.default_route_table_id
  tags                   = var.tags
}

# Route all external traffic through the internet gateway
resource "aws_route" "route_external_traffic_through_internet_gateway" {
  # We can't perform this action until our policy is in place.
  depends_on = [
    aws_iam_role_policy_attachment.provisionnetworking_policy_attachment
  ]

  route_table_id         = aws_default_route_table.the_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.the_igw.id
}
