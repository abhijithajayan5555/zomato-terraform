# =========================================================================
# Security Group webserver
# =========================================================================

resource "aws_security_group" "webserver" {
    
  name        = "webserver"
  description = "allows 80,443 traffic"
 

  ingress {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }


## New change by dev

  ingress {
    description      = ""
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webserver-${var.project}",
    project = var.project
  }
}



# =========================================================================
# Security Group ssh access
# =========================================================================

resource "aws_security_group" "remote" {
    
  name        = "remote"
  description = "allow 22 traffic"
 

  ingress {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
 
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "remote",
    project = "zomato"
  }
}


# =========================================================================
# Creating Ec2 Instance
# =========================================================================


resource "aws_instance" "application" {
    
  ami           = "ami-03fa4afc89e4a8a09"
  instance_type = "t2.micro"
  key_name = "devops"
  vpc_security_group_ids = [ aws_security_group.webserver.id , aws_security_group.remote.id ]
  tags = {
    Name = "zomato-application",
    project = "zomato"
  }
}


# ========================
# S3 BUCKET CREATION
# ========================


resource "aws_s3_bucket" "statefile" {
    
  bucket = "zomato-statefile"
  acl    = "private"
  
  versioning {
     enabled = true
  
  }
    
  tags = {
    Name = "zomato-statefile"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


