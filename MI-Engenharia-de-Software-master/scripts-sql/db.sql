-- MySQL Script generated by MySQL Workbench
-- Fri 06 May 2016 08:10:18 AM BRT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema doacao
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema doacao
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `doacao` DEFAULT CHARACTER SET utf8 ;
USE `doacao` ;

-- -----------------------------------------------------
-- Table `doacao`.`endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`endereco` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(45) NOT NULL,
  `bairro` VARCHAR(50) NOT NULL,
  `cidade` VARCHAR(20) NOT NULL,
  `cep` VARCHAR(10) NOT NULL,
  `estado` VARCHAR(20) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`campanha`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`campanha` (
  `id`                   BIGINT        NOT NULL AUTO_INCREMENT,
  `id_criador`           BIGINT        NOT NULL
  COMMENT 'Usuário criador da campanha',
  `inicio`               DATETIME      NULL
  COMMENT 'Data de início da campanha',
  `fim`                  DATETIME      NULL
  COMMENT 'Date do fim da campanha',
  `agradecimento_padrao` TEXT(500)     NULL,
  `meta`                 DOUBLE        NULL,
  `tipo`                 DECIMAL(1, 0) NULL
  COMMENT 'Define o tipo de campanha. 1=Item, 2=Financeira, 3=Tempo',
  `imagem`               VARCHAR(255)  NULL     DEFAULT 'img/campanhas/perfil-padrao.png',
  `descricao`            TEXT(5000)    NULL,
  `titulo`               VARCHAR(100)  NOT NULL,
  `ativa`                TINYINT(1)    NOT NULL DEFAULT 1,
  `paypal`               VARCHAR(45)   NULL,
  PRIMARY KEY (`id`),
  INDEX `idCriador_idx` (`id_criador` ASC),
  CONSTRAINT `idCriador`
    FOREIGN KEY (`id_criador`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
PACK_KEYS = DEFAULT;


-- -----------------------------------------------------
-- Table `doacao`.`ponto_coleta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`ponto_coleta` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `id_campanha` BIGINT NULL,
  `id_endereco` BIGINT NOT NULL,
  `telefone` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `idCampanha_idx` (`id_campanha` ASC),
  INDEX `endereco_ponto_idx` (`id_endereco` ASC),
  CONSTRAINT `id_campanha_ponto`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `endereco_ponto`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `doacao`.`endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`usuario` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(11) NOT NULL,
  `login` VARCHAR(45) NULL,
  `senha` VARCHAR(45) NULL,
  `token_facebook` VARCHAR(255) NULL,
  `token_google_plus` VARCHAR(255) NULL,
  `administrador` TINYINT(1) NULL COMMENT 'True se for administrador, false caso contrário',
  `imagem` VARCHAR(255) NULL,
  `endereco` BIGINT NULL,
  `telefone` VARCHAR(20) NULL,
  `genero` CHAR(1) NULL,
  `id_ponto_coleta` BIGINT NULL,
  PRIMARY KEY (`id`),
  INDEX `endereco_usuario_idx` (`endereco` ASC),
  INDEX `fk_usuario_1_idx` (`id_ponto_coleta` ASC),
  CONSTRAINT `endereco_usuario`
    FOREIGN KEY (`endereco`)
    REFERENCES `doacao`.`endereco` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_1`
    FOREIGN KEY (`id_ponto_coleta`)
    REFERENCES `doacao`.`ponto_coleta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = big5;


-- -----------------------------------------------------
-- Table `doacao`.`valor_campanha`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`valor_campanha` (
  `id_campanha` BIGINT NOT NULL,
  `valor` FLOAT NOT NULL,
  PRIMARY KEY (`id_campanha`, `valor`),
  CONSTRAINT `idCampanha`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`categoria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NULL,
  `imagem` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`categorias_campanha`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`categorias_campanha` (
  `id_campanha` BIGINT NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_campanha`, `id_categoria`),
  INDEX `idCategoria_idx` (`id_categoria` ASC),
  CONSTRAINT `id_campanha_categoria`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_categoria_categoria`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `doacao`.`categoria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`doacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`doacao` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `id_campanha` BIGINT NOT NULL,
  `id_usuario_doador` BIGINT NULL COMMENT 'Usuário que está doando',
  `confirmada` TINYINT(1) NULL DEFAULT 0,
  `data` DATETIME NULL DEFAULT NOW(),
  `quantidade` DOUBLE NULL,
  `descricao` VARCHAR(50) NULL,
  PRIMARY KEY (`id`),
  INDEX `id_campanha_idx` (`id_campanha` ASC),
  INDEX `id_usuario_doador_idx` (`id_usuario_doador` ASC),
  CONSTRAINT `id_campanha`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_usuario_doador`
    FOREIGN KEY (`id_usuario_doador`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`motivos_denuncia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`motivos_denuncia` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`denuncia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`denuncia` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `id_usuario` BIGINT NOT NULL,
  `id_campanha` BIGINT NOT NULL,
  `id_motivo` INT NOT NULL,
  `descricao` TEXT(500) NULL,
  PRIMARY KEY (`id`),
  INDEX `id_usuario_idx` (`id_usuario` ASC),
  INDEX `id_campanha_idx` (`id_campanha` ASC),
  INDEX `id_motivo_idx` (`id_motivo` ASC),
  CONSTRAINT `id_usuario_denuncia`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_campanha_denunciada`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_motivo_dado`
    FOREIGN KEY (`id_motivo`)
    REFERENCES `doacao`.`motivos_denuncia` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`agradecimento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`agradecimento` (
  `id_agradecimento` INT NOT NULL AUTO_INCREMENT,
  `id_remetente` BIGINT NULL,
  `id_destinatario` BIGINT NULL,
  `mensagem` TEXT(1000) NULL,
  `id_doacao` BIGINT NULL,
  PRIMARY KEY (`id_agradecimento`),
  INDEX `id_remetente_idx` (`id_remetente` ASC),
  INDEX `id_destinatario_idx` (`id_destinatario` ASC),
  CONSTRAINT `id_remetente`
    FOREIGN KEY (`id_remetente`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_destinatario`
    FOREIGN KEY (`id_destinatario`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`categoria_interesse_usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`categoria_interesse_usuario` (
  `id_categoria` INT NOT NULL,
  `id_usuario` BIGINT NOT NULL,
  PRIMARY KEY (`id_categoria`, `id_usuario`),
  INDEX `fk_categoria_interesse_usuario_2_idx` (`id_usuario` ASC),
  CONSTRAINT `fk_categoria_interesse_usuario_1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `doacao`.`categoria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_categoria_interesse_usuario_2`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `doacao`.`usuario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `doacao`.`categorias_campanha_copy1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `doacao`.`categorias_campanha_copy1` (
  `id_campanha` BIGINT NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_campanha`, `id_categoria`),
  INDEX `idCategoria_idx` (`id_categoria` ASC),
  CONSTRAINT `id_campanha_categoria0`
    FOREIGN KEY (`id_campanha`)
    REFERENCES `doacao`.`campanha` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_categoria_categoria0`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `doacao`.`categoria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;