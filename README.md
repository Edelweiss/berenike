# Berenike Project

Archaeological Resources Database for the Berenike excavation site.

## About

This is a Symfony 5 application for managing archaeological finds, buckets, loci, and excavation data from the Berenike site.

## Installation

1. Clone the repository
2. Install dependencies: `composer install`
3. Configure database in `.env`
4. Run migrations: `php bin/console doctrine:migrations:migrate`
5. Start development server: `symfony server:start`

## Features

- Find management
- Bucket tracking
- Locus documentation
- Excavation/Trench management
- User management with role-based access (ROLE_USER, ROLE_EDITOR, ROLE_ADMIN)

## Requirements

- PHP 7.4+
- MySQL/MariaDB
- Composer

## License

See LICENSE file for details.
