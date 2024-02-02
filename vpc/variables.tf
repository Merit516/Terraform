variable "vpc-cidr" {
  type        = string

}
variable "names"{
    default={
        vpc-name="my_vpc",
        igw-name="my_igw",
        
    }
}