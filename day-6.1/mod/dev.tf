aws s3api create-bucket 
  --bucket abhishek.space \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1 \
  --profile dev