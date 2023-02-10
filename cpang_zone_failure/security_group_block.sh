#!/bin/bash
aws ec2 modify-network-interface-attribute --network-interface-id eni-0869e69db2387b5c8 --groups sg-04b7fa3bd62d66e44                                                             
sleep 15
aws ec2 modify-network-interface-attribute --network-interface-id eni-0869e69db2387b5c8 --groups sg-0832e8a56ee40775e
