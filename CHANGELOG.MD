# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


## [0.0.5] - 2023-08-20
### Added
- Ajout de CDN ( AWS CloudFront )
- Ajout de certificat ssl ( ACM )
- Ajout cloudfront lambda function
- Utilisation de cache policies optimized

### Changed
- Policies bucket s3
- Migration http -> https
- Update records route53


## [0.0.4] - 2023-08-19
### Added
- www bucket redirection

## [0.0.3] - 2023-08-15
### Added
- Migration de l'infra sur un S3 backend
- Ajout OIDC github
- Ajout role + policies pour les github action

## [0.0.2] - 2023-08-15
### Added
- Ajout OIDC
- Ajout rôle + accès S3
- Ajout AssumeRole

## [0.0.1] - 2023-08-14
- Ajout provider
- Ajout CDN
- Ajout DNS
- Ajout 2 buckets S3