-- phpMyAdmin SQL Dump
-- version 4.9.5deb2ubuntu0.1~esm1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 10. Jul 2025 um 09:50
-- Server-Version: 10.3.39-MariaDB-0ubuntu0.20.04.2
-- PHP-Version: 7.4.3-4ubuntu2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `berenike`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `embridery_stitch_stitching_thread`
--

CREATE TABLE `embridery_stitch_stitching_thread` (
  `Embrodery_ID1` int(11) NOT NULL,
  `Stitch_name4` varchar(45) NOT NULL,
  `Thread_ID4` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `embridery_stitch_stitching_thread`
--

INSERT INTO `embridery_stitch_stitching_thread` (`Embrodery_ID1`, `Stitch_name4`, `Thread_ID4`) VALUES
(1, 'chain stitch', 16),
(2, 'double running stitch', 3);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `embroidery`
--

CREATE TABLE `embroidery` (
  `Embroidery_ID` int(11) NOT NULL,
  `Textile_ID7` bigint(20) NOT NULL,
  `Embroidery_description` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `embroidery`
--

INSERT INTO `embroidery` (`Embroidery_ID`, `Textile_ID7`, `Embroidery_description`) VALUES
(1, 691059, 'a circle pattern made in yellow, s2z, paired wool yarn, in chain stitch'),
(2, 911059, 'a vegetal/floral pattern in double running stitch, yellow s2z woollen thread');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `hem`
--

CREATE TABLE `hem` (
  `Hem_ID` varchar(10) NOT NULL,
  `Hem_name` varchar(45) DEFAULT NULL,
  `Hem_description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `hem`
--

INSERT INTO `hem` (`Hem_ID`, `Hem_name`, `Hem_description`) VALUES
('FH', 'folded hem', '( flat rolled hem) a rolled hem in which more cloth is taken in, and the aspect is flat'),
('RH', 'rolled hem', 'cloth is rolled in'),
('SH', 'simple hem', 'no operation is performed; the egde is sewn as it is');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `reparation`
--

CREATE TABLE `reparation` (
  `Reparation_ID` int(11) NOT NULL,
  `Textile_ID6` bigint(20) DEFAULT NULL,
  `Stitch_name3` varchar(45) DEFAULT NULL,
  `Thread_ID3` int(11) DEFAULT NULL,
  `Reparation_description` varchar(200) DEFAULT NULL COMMENT 'field that takes: darning, patching, reinforcing'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `reparation`
--

INSERT INTO `reparation` (`Reparation_ID`, `Textile_ID6`, `Stitch_name3`, `Thread_ID3`, `Reparation_description`) VALUES
(1, 1871059, 'slanting stitch', 1, 'reinforcing raveled cloth'),
(2, 2091059, 'slanting stitch', 4, 'reinforcing the hem'),
(3, 2491059, 'overcast stitch', 3, 'reinforcing the corded end of the cloth'),
(4, 1611059, 'running stitch', 8, 'a beautiful darning work as to fill in the missing portion of a weave, that spreads into rays of running stitches in the weave; the darning is made as to resenble a weave'),
(5, 1501059, 'running stitch', 8, 'a beautiful darning, possibly envisaging a radial aspect'),
(6, 200180111, 'NK', 19, 'possibly repairing an already existing seam');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `selvedge`
--

CREATE TABLE `selvedge` (
  `Selvedge_ID` varchar(30) NOT NULL,
  `Selvedge_description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `selvedge`
--

INSERT INTO `selvedge` (`Selvedge_ID`, `Selvedge_description`) VALUES
('FS', 'fringed selvedge'),
('PS', 'plaited selvedge'),
('RS1WA(1)CORD', 'reinforced selvedge over 1 warp, made of a cord'),
('RS1WA(2)', 'reinforced selvedge over one warp bundle of 2 warps'),
('RS1WA(2)EWE(1)', 'RS over 1 warp bundle of 2 warps, with one extra wrapping weft'),
('RS1WA(2)EWE(2)', 'RS over 1 warp bundle of 2 warps, with paired, extra wrapping weft'),
('RS1WA(3)', 'RS over 1 warp bundle of 3 warps'),
('RS1WA(M)', 'reinforced selvedge over 1 warp bundle containing multiple yarns (more than 3)'),
('RS1WA(M)EWE(2)', 'RS over 1 warp bundle of multiple threads, using paired extra weft'),
('RS2WA(2,2)', 'RS over 2 warp bundles, each of 2 warps'),
('RS2WA(2,2)EWE(1)', 'RS over 2 warp bundles, each of 2 warps, with extra wrpping weft'),
('RS2WA(2,2)EWE(2)', 'RS over 2 warp bundles, each of 2 warps, with extra paired wrapping weft'),
('RS2WA(3,3)', 'RS over 2 warp bundles, each of 3 warps'),
('RS2WA(3,3)EWE(1)', 'RS over 2 warp bundles, each of 3 warps, with extra wrpping weft'),
('RS2WA(3,3)EWE(2)', 'RS over 2 warp bundles, each of 3 warps, with extra paired wrapping weft'),
('RS2WA(3,3)EWE(3)', 'reinforced selvedge over 2 warp bundles, each of 3 warps, with 3 extra wrapping wefts'),
('RS2WA(3,4)1PASS', 'reinforced selvedge over 2 warp bundles, the one closer to the cloth of 3 yarns, the one at the edge of 4 yarns (grading up); the weft makes an extra pass before returning to the weave'),
('RS2WA(M,M)EWE(2)', 'RS over 2 warp bundles, each of multiple threads (more than 3), with extra wrapping weft, paired'),
('RS2WA(S4Z, S4Z)EWE(2)', 'RS over 2 warp bundles, each of an S2Z warp, with extra paired wrapping weft'),
('RS3WA(1, 1, 1)1PASS', 'RS over 3 individual warps, the weft making an extra pass before returning to the weave'),
('RS3WA(2,2,2)', 'RS over 3 warp bundles, each of 2 warps'),
('RS3WA(2,2,2)EWE(1)', 'RS over 3 warp bundles, each of 2 warps, with extra wrapping weft'),
('RS3WA(2,2,2)EWE(2)', 'RS over 3 warp bundles, each of 2 warps, with extra paired wrapping weft'),
('RS3WA(3,3,3)', 'RS over 3 warp bundles, each of 3 warps'),
('RS3WA(3,3,3)EWE(1)', 'RS over 3 warp bundles, each of 3 warps, with extra wrapping weft'),
('RS3WA(3,3,3)EWE(2)', 'RS over 3 warp bundles, each of 3 warps, with extra paired wrapping weft'),
('RS3WA(3,4,3)EWE(3)', 'RS over 3 warp bundles of 3-4-3 threads each (numbered from the inside to the edge of the piece), with extra trippled wrapping weft'),
('RS3WA(M,M,M)EWE(2)', 'RS over 3 warp bundles, each of more than 3 warps, with extra paired wrapping weft'),
('RS5WA(3,3,3,3,3)1PASS', 'RS over 5 warp bundles; each bundle of triple warp; weft makes an extra pas before returning in the weave'),
('SS', 'simple selvedge');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `spin_tightness`
--

CREATE TABLE `spin_tightness` (
  `Spin_tightness` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='This table records the spin tightness of threads, based on the observations recorded on spin angle';

--
-- Daten für Tabelle `spin_tightness`
--

INSERT INTO `spin_tightness` (`Spin_tightness`) VALUES
('loose'),
('loose-medium'),
('medium'),
('medium-tight'),
('NA'),
('NK'),
('no spin (I)'),
('tensioned'),
('tight'),
('variate'),
('very loose'),
('very tight');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `starting/finishing_border`
--

CREATE TABLE `starting/finishing_border` (
  `Starting/Finishing_Border_ID` varchar(10) NOT NULL,
  `Starting/Finishing_Border_description` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `starting/finishing_border`
--

INSERT INTO `starting/finishing_border` (`Starting/Finishing_Border_ID`, `Starting/Finishing_Border_description`) VALUES
('CB', 'Corded border'),
('FB', 'Fringed border'),
('TB', 'Tied up warps in the border');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stitch`
--

CREATE TABLE `stitch` (
  `Stitch_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `stitch`
--

INSERT INTO `stitch` (`Stitch_name`) VALUES
('backstitch'),
('chain stitch'),
('double running stitch'),
('NK'),
('overcast stitch'),
('run and fell stitch'),
('running stitch'),
('slanting stitch');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `stitching_thread`
--

CREATE TABLE `stitching_thread` (
  `Thread_ID` int(11) NOT NULL,
  `Thread_Fibre` varchar(45) DEFAULT NULL,
  `Thread_Spin/Ply` varchar(45) DEFAULT NULL,
  `Number_threads` int(11) DEFAULT NULL,
  `Thread_colour` varchar(10) DEFAULT NULL COMMENT 'Take general colours: white, yellow, red, brown, purple, blue, green, etc.',
  `Dye` varchar(4) DEFAULT NULL COMMENT 'Dye: yes, no, NK'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `stitching_thread`
--

INSERT INTO `stitching_thread` (`Thread_ID`, `Thread_Fibre`, `Thread_Spin/Ply`, `Number_threads`, `Thread_colour`, `Dye`) VALUES
(0, 'NK', 'NK', NULL, NULL, NULL),
(1, 'wool', 's', 3, 'brown', 'NK'),
(2, 'wool', 's', 2, 'yellow', 'NK'),
(3, 'wool', 's2z', 1, 'yellow', 'NK'),
(4, 'flax', 's', 3, 'brown', 'NK'),
(5, 'flax', 's', 1, 'ecru', 'NK'),
(6, 'goat hair', 's2z', 1, 'brown', 'no'),
(7, 'flax tow', 's2z', 1, 'ecru', 'no'),
(8, 'wool', 's2z', 1, 'brown', 'NK'),
(9, 'goat hair', 's2z', 1, 'yellow', 'no'),
(10, 'wool', 's2z', 1, 'blue', 'yes'),
(11, 'wool', 's2s2z', 1, 'blue', 'yes'),
(12, 'goat hair', 's2z', 2, 'brown', 'no'),
(13, 'wool', 'z', 4, 'yellow', 'no'),
(14, 'flax', 's3z', 1, 'ecru', 'no'),
(15, 'flax', 's2z', 1, 'ecru', 'no'),
(16, 'wool', 'z2s', 2, 'yellow', 'NK'),
(17, 'NK', 's2z', 1, 'brown', 'NK'),
(18, 'flax', 's3z', 1, 'ecru', 'no'),
(19, 'cotton', 's10Z', 1, 'ecru', 'no'),
(20, 'cotton', 's3z', 1, 'ecru', 'no'),
(21, 'hemp?', 'z2s', 1, 'ecru', 'no'),
(22, 'goat hair', 's2z2s', 1, 'brown', 'no'),
(23, 'flax', 's2z', 1, 'ecru', 'no'),
(24, 'wool', 's2z', 1, 'brown', 'no'),
(25, 'flax', 's', 1, 'ecru', 'no'),
(26, 'wool', 's2z', 1, 'yellow', 'yes'),
(27, 'wool', 's2z', 1, 'blue', 'yes'),
(28, 'goat hair', 's2z', 1, 'brown', 'no'),
(29, 'goat hair', 's2z', 1, 'brown', 'no'),
(30, 'goat hair', 's2z', 1, 'brown', 'no'),
(31, 'wool', 's3z', 1, 'brown', 'no'),
(32, 'flax', 's2z', 1, 'ecru', 'no'),
(33, 'wool', 's2z', 1, 'brown', 'no'),
(34, 'wool', 's', 1, 'yellow', 'NK'),
(35, 'wool', 's3z', 1, 'brown', 'no'),
(36, 'goat hair', 's2z', 4, 'brown', 'no'),
(37, 'wool', 's', 1, 'yellow', 'NK'),
(38, 'wool', 's2z', 1, 'orange', 'NK'),
(39, 'wool', 's2z2z', 1, 'yellow', 'NK'),
(40, 'hemp?', 's2z', 1, 'ecru', 'NK'),
(41, 'wool', 's3z', 1, 'multiple', 'NK'),
(42, 'goat hair', 's2z', 1, 'brown', 'no');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `structural_feature`
--

CREATE TABLE `structural_feature` (
  `Structural_feature_name` varchar(45) NOT NULL COMMENT 'takes: pile, self-banding, shorn pile, fringe, tassle, floating weft '
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `structural_feature`
--

INSERT INTO `structural_feature` (`Structural_feature_name`) VALUES
('cord'),
('fringe'),
('looped pile'),
('pile'),
('self-banding'),
('tassel');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tapestry`
--

CREATE TABLE `tapestry` (
  `Tapestry_ID` int(11) NOT NULL,
  `Weave_name1` varchar(45) DEFAULT NULL,
  `Textile_ID8` bigint(20) DEFAULT NULL,
  `Tapestry_warp_spin/ply` varchar(10) DEFAULT NULL,
  `Tapestry_weft_spin/ply` varchar(10) DEFAULT NULL,
  `Tapestry_warp_fibre` varchar(45) DEFAULT NULL,
  `Tapestry_weft_fibre` varchar(45) DEFAULT NULL,
  `Tapestry_warp_count` int(11) DEFAULT NULL,
  `Tapestry_weft_count` int(11) DEFAULT NULL,
  `Tapestry_description` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `tapestry`
--

INSERT INTO `tapestry` (`Tapestry_ID`, `Weave_name1`, `Textile_ID8`, `Tapestry_warp_spin/ply`, `Tapestry_weft_spin/ply`, `Tapestry_warp_fibre`, `Tapestry_weft_fibre`, `Tapestry_warp_count`, `Tapestry_weft_count`, `Tapestry_description`) VALUES
(1, 'weft-faced tabby', 2151059, 's2z', 's', 'wool', 'wool', 8, 45, 'A tiny portion of a tapestry weave, probably oof a clavus; only the red wool remains.'),
(2, 'weft-faced tabby', 2471059, 's', 's', 'wool', 'wool', 13, NULL, 'a tiny piece of blue tapestry weave, attached to the textile'),
(3, 'half-basket (2WA/1WE)', 1611059, 's', 's', 'wool', 'multiple', 8, 60, 'a tapestry fragment, possibly with geometric design in flax weft on a purple background'),
(4, 'weft-faced tabby', 461059, 's', 's', 'wool', 'wool', 7, 38, 'tapestry fragments with vegetal or floral decoration in red, purple and green'),
(5, 'weft-faced tabby', 2531059, 's', 's', 'wool', 'wool', 11, 30, 'a purple h- or gamma shaped motif; different torsion of the tapestry compared to the ground weave makes the textile wavy'),
(6, 'weft-faced tabby', 2961059, 's', 's', 'flax', 'wool', 9, 56, 'a fine purple looking tapestry, remains of the ground weave surrounding it, or of a motif made in flax wefts and warps remain, but not enough to suggest anythig else.'),
(7, 'weft-faced tabby', 611059, 's', 's', 'wool', 'wool', 13, 66, 'a fine monochrome tapestry with dovetailing at the edge'),
(8, 'weft-faced tabby', 600180114, 's', 's2z', 'wool', 'wool', 12, 21, 'a fine monochrome tapestry in blue weft, the weft thread is s2z, represents a rhombus with stepped lines; either part of the tapestry is flax weft, or the ground weave; I am assuming that the flax remains are part of the ground weave; also, very difficult to discern if flax or cotton'),
(9, 'half-basket', 5000190120, 's', 's', 'flax', 'wool', 7, 58, 'a fine purple and ecru tapestry, of which only the purple wool remained, in addition to an odd flax yarn in the weft and another portion of weft flax which I assume is part of the ground years; Wool wefts return in the weave in a stepped pattern, suggesting a slit tapestry; all portions of flax tapestry are now gone, impossible to say what the original pattern may have been');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tapestry_feature`
--

CREATE TABLE `tapestry_feature` (
  `Tapestry_feature_name` varchar(50) NOT NULL COMMENT 'takes: dovetailing, slit tapestry, interlocked tapestry, slant tapestry\n'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `tapestry_feature`
--

INSERT INTO `tapestry_feature` (`Tapestry_feature_name`) VALUES
('dovetailing'),
('flying needle'),
('interlocked tapestry'),
('slanting warp'),
('slanting weft'),
('slit tapestry'),
('soumak'),
('toothed tapestry'),
('warp crossing'),
('weft crossing');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tapestry_tapestry_feature`
--

CREATE TABLE `tapestry_tapestry_feature` (
  `Tapestry_ID1` int(11) NOT NULL,
  `Tapestry_feature_name1` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `tapestry_tapestry_feature`
--

INSERT INTO `tapestry_tapestry_feature` (`Tapestry_ID1`, `Tapestry_feature_name1`) VALUES
(7, 'dovetailing'),
(9, 'dovetailing'),
(5, 'interlocked tapestry'),
(4, 'slanting weft'),
(3, 'slit tapestry'),
(8, 'toothed tapestry');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile`
--

CREATE TABLE `textile` (
  `Textile_ID` bigint(20) NOT NULL DEFAULT 0,
  `bucket_id` int(11) DEFAULT NULL,
  `Textile_name` varchar(200) DEFAULT NULL,
  `Length(cm)` decimal(5,2) DEFAULT NULL,
  `Width(cm)` decimal(5,2) DEFAULT NULL,
  `Hight(cm)` decimal(5,2) DEFAULT NULL,
  `Number_of_fragments` int(11) DEFAULT NULL,
  `Function` varchar(100) DEFAULT NULL,
  `Functionality1` varchar(100) DEFAULT NULL,
  `Functionality2` varchar(100) DEFAULT NULL,
  `Textile_Item_ID1` int(11) DEFAULT NULL,
  `Ground_weave` varchar(100) DEFAULT NULL,
  `Warp_count` int(11) DEFAULT NULL,
  `Weft_count` int(11) DEFAULT NULL,
  `Perceived_thickness` varchar(20) DEFAULT NULL,
  `Warp_spin/ply` varchar(20) DEFAULT NULL,
  `Weft_spin/ply` varchar(20) DEFAULT NULL,
  `Number_warps` int(11) DEFAULT NULL,
  `Number_wefts` int(11) DEFAULT NULL,
  `Warp_spin_tightness` varchar(50) DEFAULT NULL COMMENT 'Perceived spin',
  `Weft_spin_tightness` varchar(50) DEFAULT NULL,
  `Warp_spin_angle` varchar(45) DEFAULT NULL,
  `Weft_spin_angle` varchar(45) DEFAULT NULL,
  `Warp_diameter(mm)` decimal(2,0) DEFAULT NULL,
  `Weft_diameter(mm)` decimal(2,0) DEFAULT NULL,
  `Warp_fibre` varchar(50) DEFAULT NULL,
  `Weft_fibre` varchar(50) DEFAULT NULL,
  `General_fibre` varchar(50) DEFAULT NULL,
  `Warp_colour` varchar(50) DEFAULT NULL,
  `Weft_colour` varchar(50) DEFAULT NULL,
  `Decoration` varchar(100) DEFAULT NULL,
  `General_colour` varchar(50) DEFAULT NULL,
  `Textile_description` varchar(1500) DEFAULT NULL,
  `Date_analyzed` date DEFAULT NULL,
  `Locus_addition` varchar(1024) DEFAULT NULL,
  `Date_excavation` date DEFAULT NULL,
  `migration_note` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile`
--

INSERT INTO `textile` (`Textile_ID`, `bucket_id`, `Textile_name`, `Length(cm)`, `Width(cm)`, `Hight(cm)`, `Number_of_fragments`, `Function`, `Functionality1`, `Functionality2`, `Textile_Item_ID1`, `Ground_weave`, `Warp_count`, `Weft_count`, `Perceived_thickness`, `Warp_spin/ply`, `Weft_spin/ply`, `Number_warps`, `Number_wefts`, `Warp_spin_tightness`, `Weft_spin_tightness`, `Warp_spin_angle`, `Weft_spin_angle`, `Warp_diameter(mm)`, `Weft_diameter(mm)`, `Warp_fibre`, `Weft_fibre`, `General_fibre`, `Warp_colour`, `Weft_colour`, `Decoration`, `General_colour`, `Textile_description`, `Date_analyzed`, `Locus_addition`, `Date_excavation`, `migration_note`) VALUES
(371059, 156, 'fragments of yellow wool weave', '4.40', '2.50', '0.00', 3, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 38, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'three small pieces of neatly woven wool weave, with selvedge preserved', NULL, NULL, '2010-01-13', NULL),
(381059, 156, 'fragment of sturdy flax weave', '23.00', '4.80', '0.00', 3, 'household/industrial', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 23, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '3 fragments of sturdy and coarse flax weave.', NULL, NULL, '2010-01-13', NULL),
(391059, 156, 'yellow woollen cord', '27.00', '0.50', '0.00', 2, 'cord', 'padding fill', 'NK', 4, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a selvedge-like cord for tying up', NULL, NULL, '2010-01-13', NULL),
(401059, 156, 'fragment of coarse cotton weave', '10.20', '7.50', '0.00', 2, 'household/industrial', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 12, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of heavy duty cotton weave', NULL, NULL, '2010-01-13', NULL),
(411059, 156, 'fragments of red wool weave', '3.80', '2.70', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 8, 8, 'NK', 's2z', 's', 1, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'red', 'red', NULL, 'red', 'a fragment of half basket weave in red wool; fragments of a cord, too deteriorated to assess function but possibly a corded border?', NULL, NULL, '2010-01-13', NULL),
(421059, 156, 'fragments of goat hair weave', '4.00', '3.00', '0.00', 3, 'furnishing/industrial', 'NK', 'NK', NULL, 'balanced tabby', 4, 4, 'NK', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '3 fragments of coarse goat hair weave', NULL, NULL, '2010-01-13', NULL),
(431059, 156, 'fragments of yellow woollen weave', '4.30', '2.60', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 28, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '2 fragments of woollen weave, possibly from a garment', NULL, NULL, '2010-01-13', NULL),
(441059, 156, 'fragments of plain, ecru woollen weave', '6.00', '1.70', '0.00', 2, 'garment/furnishing', 'NK', 'NK', NULL, 'warp-faced tabby', 16, 8, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', 'fragment of woollen weave, with simple selvedge preserved', NULL, NULL, '2010-01-13', NULL),
(451059, 156, 'fragment of dark yellow woollen weave', '4.60', '2.10', '0.00', 1, 'garment/furnishng', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 15, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragment of dark-yellow woollen weave', NULL, NULL, '2010-01-13', NULL),
(461059, 156, 'fragments of tapestry from garment', '8.50', '6.50', '0.00', 5, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 7, 38, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'tapestry', 'yellow', '2 sections of the tapestry probably from a garment; one discoverd in pb007 and one in pb011; floral or vegetal motifs', NULL, 'C; West Baulk Trim', '2010-01-13', 'Zusätzliche Zuordnug zu Bucket 11 (2010-01-16)'),
(471059, 156, 'fragment of coarse woollen weave', '7.50', '3.50', '0.00', 1, 'furnishing', 'NK', 'NK', NULL, 'balanced tabby', 4, 4, 'NK', 'z2s', 'z2s', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'brown', NULL, 'brown', 'a fragment of thick woollen weave, possibly not sheep\'s wool', NULL, NULL, '2010-01-13', NULL),
(481059, 156, 'fragment of plain cotton weave', '12.50', '4.50', '0.00', 1, 'household/industrial', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 18, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a fragment of cotton weave with hem preserved, remains of secondary stitch on the hem, unknown function', NULL, NULL, '2010-01-13', NULL),
(491059, 156, 'plaited cord attached to the seam section of a cloth', '25.50', '0.40', '0.00', 1, 'cord', 'NK', 'NK', 5, NULL, NULL, NULL, 'NK', 's2z', NULL, NULL, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', '', NULL, NULL, NULL, 'bucket unclear'),
(551059, 164, 'fragments of furnishing cotton cloth with wool stripes and pile', '15.70', '13.20', '0.00', 4, 'furnishing', 'padding fill', 'NK', NULL, 'weft-faced tabby', 5, 16, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'multiple', 'cotton', 'ecru', 'multiple', 'stripe', 'ecru', 'a fragment, possibly of a furnishing item, made in cotton and provided with a pile; stripes in the weft made by the addition of yellow/blue wool thread; RS preserved', NULL, NULL, '2010-01-17', NULL),
(561059, 164, 'fragments of flax cord', NULL, NULL, NULL, 3, 'cord', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z2s', NULL, 1, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'flax', '', 'flax', 'ecru', NULL, NULL, 'ecru', '3 fragments of badly decayed flax rope', NULL, NULL, '2010-01-17', NULL),
(571059, 164, 'fragments of cotton cord with knot', '2.00', '2.00', '0.00', 3, 'cord', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z6s', NULL, 1, NULL, 'tight', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'fragments of cotton cord with a knot', NULL, NULL, '2010-01-17', NULL),
(581059, 164, 'fragment of cotton cord', '7.60', '0.20', '0.00', 1, 'cord', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 's3z', NULL, 1, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'a fragmet of cord in cotton', NULL, NULL, '2010-01-17', NULL),
(591059, 150, 'cotton basket weave', '2.50', '2.50', '0.00', 3, 'household/industrial', 'NK', 'NK', NULL, 'basket (2WA/2WE)', 5, 6, 'NK', 's', 's', 2, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a cotton weave; found in PB001 and PB036; matches perfectly; the larger fragment has a stripe made of 2 s-spun, blue wool threads; unknown purpose of this stripe, maybe marking a certain length of cloth that was woven?', NULL, 'the piece from PB001', '2010-01-04', 'zusätzliche Zuordnung zu Locus 4 (B; South Baulk Trim; the piece from PB036) und PB036'),
(601059, 185, 'fragment of cotton heavy duty weave', '2.70', '2.00', '0.00', 1, 'furnishing/industrial', 'NK', 'NK', NULL, 'basket (2WA/2WE)', 5, 5, 'NK', 's', 's', 2, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a badly decayed and small cotton weave', NULL, 'B; South Baulk Trim', NULL, NULL),
(611059, 185, 'fragment of monochrome tapestry in wool', NULL, NULL, NULL, 3, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 62, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'tapestry', 'yellow', 'three fragments of a monochrome tapestry of high quality, presumably decorating once a garment.', NULL, 'B; South Baulk Trim', NULL, NULL),
(621059, 185, 'fragments of faded blue cotton textile', '10.00', '2.00', NULL, 2, 'furnishing/household', 'NK', 'NK', NULL, 'balanced tabby', 10, 10, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'blue', 'blue', NULL, 'blue', 'fragments of much decayed and faded blue cotton textile, found associated with a plant kernel (?); poece possibly dyed in one piece', NULL, 'B; South Baulk Trim', NULL, NULL),
(631059, 187, 'fragments of coarse flax tow? weave', '4.90', '2.30', '0.00', 5, 'furnishing/industrial', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 8, 'NK', 'z', 'z', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'fragments of heavy duty flax tow (?) textile', NULL, 'C; West Baulk Trim', NULL, NULL),
(641059, 187, 'fragments of yellow wool weave', '6.70', '2.50', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 11, 14, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragments of loose yellow textile', NULL, 'C; West Baulk Trim', NULL, NULL),
(651059, 187, 'fragments of goat hair weave', '6.40', '4.20', '0.00', 2, 'furnishing/industrial', 'NK', 'NK', NULL, 'balanced tabby', 4, 4, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a fragment of heavy duty goat hair textile, with simple selvedge passed around a cord; initially proposed as shoe sole, but I am not convinced anymore;', NULL, 'C; West Baulk Trim', NULL, NULL),
(661059, 187, 'fragment of blue, woollen textile', '3.10', '1.80', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 42, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a tiny fragment of blue woollen weae with preserved selvedge', NULL, 'C; West Baulk Trim', NULL, NULL),
(671059, 187, 'fragments of checked cotton textile', '21.50', '18.00', '0.00', 3, 'garment/furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 24, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'fragments of checked textile made of cotton, with fringed servedge', NULL, 'C; West Baulk Trim', NULL, NULL),
(681059, 187, 'fragments of cotton checked textile', '23.00', '5.00', '0.00', 2, 'garment/furnishing', 'tying up', 'NK', NULL, 'weft-faced tabby', 15, 34, 'NK', 's2z', 'z', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'fragments of checked textile with blue checks, cotton', NULL, 'C; West Baulk Trim', NULL, NULL),
(691059, 187, 'fragment of embroidered wool cloth', '4.00', '1.40', '0.00', 1, 'garment/furnishing', 'NK', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 'z2s', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'embroidery', 'multiple', 'a tiny fragment of tabby wool weave with embroidered circles, in yellow wool, chain stitch.', NULL, 'C; West Baulk Trim', NULL, NULL),
(701059, 187, 'fragment of goat hair weave', '5.50', '4.30', '0.00', 2, 'furnishing/industrial', 'NK', 'NK', NULL, 'balanced tabby', 4, 4, 'NK', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a heavy duty goat hair weave', NULL, 'C; West Baulk Trim', NULL, NULL),
(711059, 157, 'fragments of yellow woollen weave', '4.00', '1.60', '0.00', 3, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 10, 11, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '3 scraps of yellow woollen weave', NULL, NULL, '2010-01-14', NULL),
(721059, 157, 'fragment of yellow woollen selvedge', '2.50', '0.50', '0.00', 1, 'garment', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fragment of woollen reinforced selvedge; interestingly the wrapping weft makes an extra pass; wrapping weft is an s2z', NULL, NULL, '2010-01-14', NULL),
(731059, 157, 'fragments of wool weave indigo wool theards associated', '7.30', '4.80', '0.00', 5, 'garment/household', 'padding fill', 'NK', NULL, 'weft-faced tabby', 7, 12, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragment of wool weave; indigo wool threads wrapped around loose threads without apparent function', NULL, NULL, '2010-01-14', 'Zusätzliche Zuordnug zu Bucket 9 (2010-01-14)'),
(741059, 157, 'fragment of ecru cord', '13.50', '0.40', '0.00', 1, 'cord', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z4s', NULL, 1, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'fragment of cotton cord', NULL, NULL, '2010-01-14', NULL),
(751059, 157, 'fragment of flax tow/palm fibre', '7.80', '0.40', '0.00', 1, 'cord', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's2z', NULL, 1, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'NK', '', 'NK', 'ecru', NULL, NULL, 'ecru', 'cord made of an unknown material, possibly flax tow or palm fibre?', NULL, NULL, '2010-01-14', NULL),
(761059, 157, 'fragment of cotton cord', '9.00', '0.30', '0.00', 1, 'cord', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z2s', NULL, 1, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'cotton cord', NULL, NULL, '2010-01-14', NULL),
(771059, 158, 'fragment of blue wool weave, possibly tapestry', '2.70', '1.90', '0.00', 1, 'garment', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 24, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'blue', NULL, 'blue', 'fragment of wool weave, possibly from a tapestry, but too small to argue that', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(781059, 158, 'fragment of wool weave, probably from tapestry', '4.50', '1.30', '0.00', 1, 'garment', 'padding fill', 'NK', NULL, 'weft-faced tabby', 8, 40, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'brown', NULL, 'brown', 'a tiny fragment of presumably tapestry weave; impossible to demonstrate as no remains of the ground weave exist', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(801059, 4910, 'wrapping thread', NULL, NULL, NULL, 1, 'thread', 'NK', 'NK', 3, NULL, NULL, NULL, 'NK', 's', NULL, 5, NULL, 'NK', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'yellow', NULL, NULL, 'yellow', 'the yarns with which TX150 was wrapped and fastened', NULL, 'A; East Baulk Trim', '2009-12-20', NULL),
(811059, 158, 'fragment of coarse cotton weave', '6.70', '5.20', '0.00', 1, 'furnishing/industrial', 'padding fill', 'NK', NULL, 'balanced tabby', 10, 10, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'coarse cotton textile', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(821059, 158, 'fragment of flax textile', '2.70', '2.70', '0.00', 1, 'garment/household', 'padding fill', 'NK', NULL, 'warp-faced tabby', 16, 8, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a flax textile with simple selvedge preserved', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(831059, 158, 'fragments of loosened wool thread in blue', '2.50', '2.00', '0.00', 2, 'garment/furnishing', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'blue', NULL, NULL, 'blue', 'unraveled yarns probably from a weave', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(841059, 158, 'fragment of yellow wool weave', '4.60', '2.10', '0.00', 1, 'garment/furnishing', 'padding fill', 'NK', NULL, 'balanced tabby', 11, 13, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a medium-quality, featureless yellow woollen weave', NULL, 'A; East Baulk Trim', '2010-01-14', NULL),
(851059, 155, 'fragment of yellow woollen cord ', '6.00', '0.80', '0.00', 1, 'cord', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'selvedge-like yellow woollen cord', NULL, NULL, NULL, NULL),
(861059, 155, 'fragment of open blue weave with pink stripe', '10.00', '4.00', '0.00', 1, 'shawl', 'NK', 'NK', NULL, 'balanced tabby', 14, 12, 'NK', 'z2s', 'z2s', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'multiple', 'stripe', 'blue', 'fragment of open weave, blue wool, decorated by means of a pink stripe in the weft; the stripe must have been of 3.5 cms in width, and contained approximately 56 wefts', NULL, NULL, NULL, NULL),
(871059, 155, 'fragments of plain flax weave with blue stripe', NULL, NULL, NULL, 2, 'garment/furnishing', 'NK', 'NK', NULL, 'balanced tabby', 12, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'multiple', 'ecru', 'stripe', 'ecru', 'fragments of flax weave, with a blue stripe in the presumed warp; larger piece was once stitched, now only the holes survive; smaller piece was folded into half and stitched, with unknown purposes.', NULL, NULL, NULL, NULL),
(881059, 155, 'fragment of yellow woollen weave', NULL, NULL, NULL, 1, 'garment/furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 22, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fragment of yellow woollen weave, without features', NULL, NULL, NULL, NULL),
(891059, 155, 'fragments of hem and corded border of yellow woollen textile', '7.00', '5.50', '0.00', 6, 'garment', 'tying up', 'NK', NULL, 'weft-faced tabby', 10, 30, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragments from one or two different textiles from the ground weave and the corded border; the remains of the corded border were tyed up and knowtted onto a weave fragment rolled up for the purpose and stitched, presumably for fastening or carrying purposes?', NULL, NULL, NULL, NULL),
(901059, 187, 'fragments of checked cotton textile', '3.50', '3.00', '0.00', 1, 'garment/furnishing', 'NK', 'NK', NULL, 'warp-faced tabby', 50, 12, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'fragment of cotton textile with check pattern in blue, simple selvedge preserved', NULL, 'C; West Baulk Trim', NULL, NULL),
(911059, 155, 'fragment of rolled red woollen textile with blue stripe and embroidery', '9.80', '2.80', '0.00', 1, 'garment', 'padding fill', 'NK', NULL, 'balanced tabby', 13, 16, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'red', 'multiple', 'multiple', 'red', 'fragment of a red woollen weave with preserved reinforced selvedge; 2 blue stripes in the weft. Floral or vegetal motif embroidered; piece was carefully rolled possibly in view of being used as padding fill.', NULL, NULL, NULL, NULL),
(921059, 161, 'fragments of cotton checked textile', '14.00', '2.50', '0.00', 6, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 14, 21, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'ecru', 'fragments of thin, cotton, check patterned textile, with the blue warps and wefts of cotton as well', NULL, 'for piece in PB012, D; North Baulk Trim', '2010-01-16', 'Zusätzliche Zuordnug zu Bucket 6'),
(931059, 155, 'fragment of brown woollen weave', '26.00', '4.00', '0.00', 1, 'shawl', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 24, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'relatively open weave, maybe from lightweight shawl', NULL, NULL, NULL, NULL),
(941059, 155, 'fragment of cotton weave', '2.50', '2.30', '0.00', 2, 'furnishing/industrial', 'NK', 'NK', NULL, 'basket (2WA/2WE)', NULL, NULL, 'NK', 's', 's', 2, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'heavy duty cotton weave', NULL, NULL, NULL, NULL),
(951059, 155, 'fragment of woollen weave', '3.30', '2.60', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 10, 8, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, NULL, NULL),
(961059, 155, 'fragments of blue woollen cord', '4.00', '0.50', '0.00', 2, 'cord', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'cord made by means of wrapping tripled weft yarn around three bundles of 3 warps each', NULL, NULL, NULL, NULL),
(971059, 155, 'fragments of hem region of cotton textile', '6.00', '0.70', '1.00', 3, 'household/industrial', 'NK', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'medium coarse plain cotton textile with rolled hem', NULL, NULL, NULL, NULL),
(981059, 154, 'fragments of coarse flax weave', '7.40', '2.00', '0.00', 2, 'household/industrial', 'NK', 'NK', NULL, 'warp-faced tabby', 16, 6, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'fragments of flax weave, one of them preserving the hem area; stitch too decayed to be analyzed, slanted stitch with flax thread;', NULL, NULL, NULL, 'Zusätzliche Zuordnug zu Bucket 6'),
(991059, 155, 'fragment of coarse goat hair weave', '19.00', '10.50', '0.00', 1, 'furnishing/industrial', 'NK', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'remains of a very coarse goat hair weave, possibly a carpet or sack; found associated with decayed hide, straw, woode pieces, and hair (human?)', NULL, NULL, NULL, NULL),
(1001059, 155, 'fragments of rolled, yellow woollen weave', '4.80', '3.00', '0.00', 3, 'garment', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 36, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'neatly folded yellow woollen textile, possibly for padding purposes; piece is very decayed, either from being burned, or from adhering to other easy decomposable organic materials.', NULL, NULL, NULL, NULL),
(1011059, 154, 'fragments of selvedge area of yellow woollen weave', '4.70', '1.40', '0.00', 3, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 25, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragments of neatly woven yellow weave in wool, reinforced selvedge preserved', NULL, NULL, '2010-01-11', 'Zusätzliche Zuordnug zu Bucket 6'),
(1021059, 154, 'compound weave textile with geometric design', '14.30', '9.60', '0.00', 1, 'furnishing', 'NK', 'NK', NULL, 'weft-faced compound', 19, 44, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'multiple', 'multiple', NULL, 'multiple', 'a woollen  compound weave with a repetitive pattern of lzenges and lines, resembling the key motif; item was stitched at a later point', NULL, NULL, '2010-01-11', NULL),
(1031059, 154, 'fragments of heavy duty woollen weave ', '9.40', '6.70', '0.00', 2, 'furnishing', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 9, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'multiple', 'multiple', NULL, 'brown', 'a heavy duty woollen weave with alternating yellow and brown yarns in both systems; both fragments were neatly rolled, possibly to be used as padding fill? the fragment from PB004 appears to have been tyed up with a leather string, much decayed now;', NULL, NULL, '2010-01-11', 'Zusätzliche Zuordnug zu Bucket 4'),
(1041059, 154, 'half-basket cotton weave, coarse and decayed', '6.00', '5.50', '0.00', 6, 'household/industrial', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 7, 4, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'self-banding', 'ecru', 'a heavy duty and much decayed cotton cloth, with self-banding by means of quadrupling the wefts', NULL, NULL, '2010-01-11', NULL),
(1051059, 154, 'fragment of decayed yellow wollen weave', '2.60', '2.40', '0.00', 1, 'garment/furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 20, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'simple selvedge preserved', NULL, NULL, '2010-01-11', NULL),
(1061059, 154, 'fragments of yellow woollen weave with selvedge', '8.00', '6.00', '0.00', 3, 'garment', 'padding fill', 'NK', 4, 'balanced tabby', 11, 13, 'NK', 's', 's', 1, 1, 'loose', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'two fragments of yellow wool weave, one of which has a surviving reinforced selvedge, and was neatly rolled and tyed up, presumably to function as padding fill; this was made with the help of a selvedge like cord, the fragments of which survive on the rolled cloth, as much as unassociated with it; in addition, a knot appears to have been made with the same yarns from the yellow weave', NULL, NULL, '2010-01-11', 'Zusätzliche Zuordnug zu Bucket 8 (2010-01-14)'),
(1071059, 153, 'fragments of brown woollen weave with yellow stripes', '3.40', '2.10', '0.00', 2, 'garment/furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 7, 20, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'brown', 'fragments of a tightly woven woollen weave with 3 stripes in yellow in the weft; associated with straw and decayed leather fragments', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1081059, 154, 'fragments of flax weave', '6.90', '4.20', '0.00', 5, 'garment/household', 'NK', 'NK', NULL, 'balanced tabby', 17, 21, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-11', NULL),
(1091059, 153, 'fragments of a woollen textile with a patch', '0.00', '0.00', '0.00', 10, 'garment', 'Nk', 'NK', NULL, 'weft-faced tabby', 11, 46, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'stripe', 'yellow', 'fragments of yellow wollen weave, initially interpreted as a bag, then as parts of a larger patch; remains of a seam and various other stitches', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1101059, 154, 'fragment of unraveled red woollen textile with blue threads', '2.50', '1.20', '0.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'red', 'red', NULL, 'red', 'fragment too decayed to assess any technical feature; presence of blue threads sends to a connection with inv no 911059', NULL, NULL, '2010-01-11', NULL),
(1111059, 154, 'fragment of partially unraveled blue woollen textile', '6.50', '1.50', '0.00', 1, 'NK', 'tying up', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a partially unraveled blue woollen textile', NULL, NULL, '2010-01-11', NULL),
(1121059, 154, 'a tassel/lump of multicolured woollen threads', '8.70', '3.40', '0.00', 1, 'toy', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's2z', NULL, NULL, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'multiple', NULL, NULL, 'multiple', 'a curious piece: multiple woollen threads were twisted together; at each end, a blue thread was plaited as to form a God\'s eye pattern; possibly a tassle, large fringe, or a fragment of some sort of toy?', NULL, NULL, '2010-01-11', NULL),
(1131059, 152, 'fragment of cotton weave with plaited border', '4.30', '1.80', '0.00', 5, 'NK', 'NK', 'NK', NULL, 'warp-faced tabby', 12, 8, 'NK', 'z', 'z', 1, 1, 'medium', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'very well preserved plaited endor begining of cloth', NULL, NULL, '2010-01-09', 'Zusätzliche Zuordnug zu Bucket 4 (2010-01-10)'),
(1141059, 153, 'fragments of eatureless yellow woollen textile', '3.00', '2.40', '0.00', 5, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 17, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'remains of stitching of unknown purpose survive', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1151059, 154, 'fragment of sheep\'s skin with wool', '5.50', '3.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'yellow', NULL, NULL, 'yellow', 'sheep\'s skin with wool', NULL, NULL, '2010-01-11', NULL),
(1161059, 154, 'fragments of cotton textile', '8.00', '2.40', '0.00', 4, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 26, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-11', NULL),
(1171059, 154, 'fragments of goat hair weave', '7.60', '4.00', '0.00', 4, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 4, 5, 'NK', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '', NULL, NULL, '2010-01-11', NULL),
(1181059, 154, 'fragments of seam area (attached to a plaited cord) ', '12.00', '1.70', '0.00', 1, 'NK', 'NK', 'NK', 5, 'weft-faced tabby', 7, 11, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'the seam section was found attached to a plaited cord.', NULL, NULL, '2010-01-11', NULL),
(1191059, 154, 'fragments of coarse wool textile', '4.10', '3.70', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 7, 6, 'NK', 's', 's', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, '2010-01-11', NULL),
(1201059, 154, 'fragments of resist-dyed cotton textile', '4.00', '3.30', '0.00', 4, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 19, 30, 'NK', 's2z', 's2z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'floral', 'multiple', 'a so-called \"Indian\"\" resist-dyed cotton textile', NULL, NULL, '2010-01-11', NULL),
(1211059, 153, 'fragments of decayed and badly twisted wooled weave', '0.00', '0.00', '0.00', 3, 'shawl', 'tying up', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1221059, 154, 'fragments of cotton weave', '3.80', '3.30', '0.00', 10, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 7, 9, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'the larger fragment has been tightly rolled', NULL, NULL, '2010-01-11', NULL),
(1231059, 154, 'fragments of flax weave', '4.10', '1.90', '0.00', 3, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 7, 12, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-11', NULL),
(1241059, 153, 'scraps of open woollen weave with yellow stripe', '0.00', '0.00', '0.00', 4, 'shawl', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'multiple', 'brown', 'stripe', 'brown', 'a much ragged woollen weave; initially probably from a shawl; the decayed state and the fact that it was enmeshed with other equally decayed textiles suggest that it was used as padding fill', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1251059, 154, 'fragments of yellow woollen weave wrapped around a rope', '7.50', '0.70', '0.00', 5, 'NK', 'tying up', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'the textile is in very decayed condition, much loosened and unraveled; tension on the pieces suggest that they were used for fastening purposes after they decayed too much for their initial function; 3 fragments were wrapped around thick animal hair? ropes, suggesting that they were used for protecting the areas in contact with the ropes? Basket handles or a beast of burden\'s girth? ', NULL, NULL, '2010-01-11', NULL),
(1261059, 153, 'cloth selvedge knotted and reused for fastening', '15.00', '2.30', '0.00', 1, 'NK', 'tying up', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'selvedge preserved; cloth knotted and reused for fastening purposes', NULL, NULL, '2010-01-10', NULL),
(1271059, 153, 'blue woollen shawl?', '27.50', '7.40', '0.00', 5, 'shawl', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 11, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'blue shawl? of wool with a reinforced selvedge', NULL, 'no addtion for first piece; second, B; South Baulk Trim ', '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 10 (2010-01-14)'),
(1281059, 153, 'fragment of corded border of yellow woollen weave', '49.00', '1.20', '0.00', 1, 'garment', 'tying up', 'NK', NULL, NULL, 7, 0, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'corded border from presumably a garment, that was transformed into a tying strap after it had decayed; fragment was rolled along the cord and stitched', NULL, NULL, '2010-01-10', NULL),
(1291059, 153, 'fragments of heavy duty woollen textile', '14.00', '10.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 13, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, '2010-01-10', NULL),
(1301059, 153, 'stripe of knotted, blue-checked textile ', '8.80', '3.90', '0.00', 1, 'NK', 'tying up', 'NK', NULL, 'weft-faced tabby', 17, 34, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'a fine cotton weave, possibly from a shawl, tunic, or soft furnighing item; after it had decayed, the textile was torn to narrow strips so it could be used for fastening; fragment preserves also a knot.', NULL, NULL, '2010-01-10', NULL),
(1311059, 153, 'fragments of ecru cotton weave', '6.00', '4.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 16, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-10', NULL),
(1321059, 153, 'fragment of yellow woollen weave', '9.60', '2.80', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 9, 12, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, '2010-01-10', NULL),
(1331059, 153, 'fragment of ecru flax weave', '26.50', '3.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 14, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-10', NULL),
(1341059, 153, 'fragment of fine brown wool weave', '9.20', '5.60', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 56, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a fine piece of wool weave, with reinforced selvedge preserved; possibly comes from a garment', NULL, NULL, '2010-01-10', NULL),
(1351059, 153, 'fragment of knotted yellow woollen textile', '5.30', '2.50', '0.00', 1, 'NK', 'tying up', 'NK', NULL, 'warp-faced tabby', 17, 12, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'textile was knotted for an unknown purpose', NULL, NULL, '2010-01-10', NULL),
(1361059, 154, 'fragments of plain, ecru flax weave', '8.30', '6.50', '0.00', 4, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 16, 16, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'featureless textile', NULL, NULL, '2010-01-11', NULL),
(1371059, 154, 'fragment of brown wool weave', '3.50', '3.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 14, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'featureless textile', NULL, NULL, '2010-01-11', NULL),
(1381059, 154, 'rags of brown wool textile with plaited border', '0.00', '0.00', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'plaited border preserved', NULL, NULL, '2010-01-11', NULL),
(1391059, 154, 'fragments of cotton weave', '5.50', '2.70', '0.00', 2, 'NK', 'tying up', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'the fragment containing the selvedge appears to have been used for tying up, as the temsion in the weave suggests. The other fragment was tightly rolled.', NULL, NULL, '2010-01-11', NULL),
(1401059, 153, 'fragments of selvedge portion of wool weave with knot', '6.50', '3.00', '0.00', 4, 'garment', 'tying up', 'NK', NULL, 'balanced tabby', 8, 8, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragments of a much decayed selvedge area presumably from a garment; at a later point, these strips appear to have been used for fastening. One of the fragments was knotted', NULL, NULL, '2010-01-10', NULL),
(1411059, 153, 'fragments of flaw weave', '9.80', '4.00', '0.00', 3, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 8, 11, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-10', NULL),
(1421059, 153, 'rags of purple? wool cloth', '15.00', '2.00', '0.00', 4, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 18, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'purple', NULL, 'purple', 'interesting pile of rags; the wet yarns seem to have been either dark purple or brown, or at least have decayed to this colour', NULL, NULL, '2010-01-10', NULL),
(1431059, 153, 'fragments of cotton weave with loose thread', '3.00', '3.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 14, 'NK', 's', 's', 1, 1, 'NK', 'loose', NULL, NULL, NULL, NULL, 'flax tow?', 'flax tow?', 'flax tow?', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-10', NULL),
(1441059, 153, 'fragment of yellow wool weave', '6.80', '1.80', '0.00', 1, 'NK', 'tying up', 'NK', NULL, 'weft-faced tabby', 7, 11, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, '2010-01-10', NULL),
(1451059, 153, 'fragments of finely-woven cotton textile', '7.50', '2.00', '0.00', 6, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 29, 26, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-10', NULL),
(1461059, 153, 'fragments of plaited cord', '5.50', '0.40', '0.00', 2, 'tying up', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', NULL, NULL, NULL, 'tight', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'yellow', NULL, NULL, 'yellow', 'plait made with two bundles of yarns each of three threads, wrapped over 2 bundles of yarns, likewise, each of three threads.', NULL, NULL, '2010-01-10', NULL),
(1471059, 153, 'fragment of wool weave with rolled hem', '13.00', '1.20', '0.00', 1, 'garment', 'tying up', 'NK', NULL, 'weft-faced tabby', 14, 27, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'part of the textile seems to have been rolled and sewn into a hem as reinforcement, and not as original feature.', NULL, NULL, '2010-01-10', NULL),
(1481059, 153, 'fragments of red and blue diamond twill textile', '6.00', '3.00', '0.00', 3, 'garment', 'NK', 'NK', NULL, 'diamond twill', 11, 28, 'NK', 's', 'z', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'red', 'blue', NULL, 'blue', '3 fragile fragments of weft-faced diamond twill', NULL, 'piece from pottery bucked 12 comes from D; North Baulk Trim', '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 12 (2010-01-16)'),
(1501059, 153, 'fine woollen tunic', '40.50', '21.00', '0.00', 3, 'garment', 'tying up', 'NK', 3, 'weft-faced tabby', 13, 40, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'stripe', 'multiple', 'The larger fragment of the textile was found while upon visiting 59 in December 2014, due to a partial fall of one of the trench walls; about 5 cms of the fragment were laying in the open air; the quality of the piece made the recovery a must. The recovered fragment was tied and knotted, the knot being secured with a bundle of loose wool fibers around it, tied at their turn 3 times, then knotted; apparently the fragment was used as fastening cloth after it had degraded too much for its initial function; fine weave in wool with yellow, red and brown bands alternating; most probably from a garment or a fine furnishing', NULL, 'C; West Baulk Trim; a second piece recovered from S baulk, 09.12.2014', '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 11 (2010-01-16) und 999 (2014-12-01)'),
(1511059, 153, 'yellow woollen thread', '0.00', '0.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's2z2s', NULL, 1, 0, 'medium', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'yellow', NULL, NULL, 'yellow', '', NULL, NULL, '2010-01-10', NULL),
(1521059, 153, 'fragment of knotted woollen textile', '3.30', '1.70', '0.00', 1, 'NK', 'tying up', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'textile has been knotted probably to fasten something', NULL, NULL, '2010-01-10', NULL),
(1531059, 153, 'yellow woollen stripe with brown stripe, rolled tightly', '16.00', '2.90', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 24, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'stripe', 'yellow', 'stripe of woollen weave with a decoration in the shape of a brown stripe in the weft; a blue-yellow wool thread, s2z, was stitched onto the edge of the fragment at an unknown date befre it was rolled; these are thus two unconnected, individual actions; unknown function for the stitching', NULL, NULL, '2010-01-10', NULL),
(1541059, 153, 'goat hair weve', '5.50', '3.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 4, 4, 'NK', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '', NULL, NULL, '2010-01-10', NULL),
(1551059, 153, 'fragments of dark yellow wool weave', '4.70', '3.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 40, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'self-banding', 'yellow', 'self banding by means of doubling the weft; occurs only once', NULL, NULL, '2010-01-10', NULL),
(1561059, 151, 'fragment of fine monochrome wool tapestry in brown', '9.30', '4.30', '0.00', 3, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 12, 24, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'tapestry', 'yellow', 'monochrome tapestry of rectangular shape, possibly a tabula? Decorative slanting stitching on the tapestry area', NULL, NULL, '2010-01-07', 'Zusätzliche Zuordnug zu Bucket 4 (2010-01-10)'),
(1571059, 152, 'fine flax scraps', '4.70', '2.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 12, 26, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self-banding', 'ecru', 'very fine piece; 2 rows of self bands made by means of doubling the warp', NULL, NULL, '2010-01-09', NULL),
(1581059, 152, 'fine flax textile', '4.70', '2.00', '0.00', 3, 'NK', 'NK', 'NK', NULL, 'warp-faced tabby', 16, 10, 'NK', 'z2s', 's', 16, 10, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-09', NULL),
(1591059, 153, 'wool unraveled textile', '3.50', '2.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a much unraveled blue textile in blue wool', NULL, NULL, '2010-01-10', NULL),
(1601059, 150, 'fragment of tapestry-decorated furnishing textile', '15.00', '9.00', '0.00', 1, 'furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 25, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'green', 'tapestry', 'green', 'a beautiful, tapestry-decorated furnishing item; decorated by means of scattered flower buds; piece was associated with lumps of yarns and other decayed textiles; the textile wrapped a stone, impossible to say if on purpose or accidentaly during deposition', NULL, NULL, '2010-01-04', NULL),
(1611059, 150, 'high quality woollen garment', '9.00', '7.20', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'half-basket (2WA/1WE)', 8, 60, 'NK', 's', 's', 2, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'purple', 'tapestry', 'purple', 'a fine woollen textile, tapestry woven, probably from a garment; flying needle technique for the decoration, but unfortunately the design, which may have been geometric, has entirely vanished; the textile was carefully repaired by means of darning; excellent job;', NULL, NULL, '2010-01-04', NULL),
(1641059, 153, 'blue woollen weave', '5.50', '1.70', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'half-basket (2WA/1WE)', 9, 22, 'NK', 's', 's', 2, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'blue', NULL, 'blue', 'a woollen weave with blue wefts on doubled warps', NULL, NULL, '2010-01-10', NULL),
(1651059, 153, 'wool textile', '5.00', '2.50', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 20, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a small woollen textile', NULL, NULL, '2010-01-10', NULL),
(1661059, 153, 'blue and ecru unraveled? wool', '4.50', '2.00', '1.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'blue', NULL, NULL, 'blue', 'a piece of unspun or unraveled wool, dyed blue, found attached to an ecru piece of similar nature, an animal hair piece, and straw', NULL, NULL, '2010-01-10', NULL),
(1671059, 153, 'cotton textile', '5.50', '2.00', '1.00', 8, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 32, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a cotton textile, associated with wood and possibly degraded leather', NULL, NULL, '2010-01-10', NULL),
(1681059, 152, 'fragment of fine flax weave with wool/linen, tapestry-made h-shape?', '3.70', '2.50', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 16, 15, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'tapestry', 'ecru', 'interestin piece, one of the finest flax weaves examined during 2014; monochrome tapestry made by inserting dark red or brown wool/leather? wefts besides the existing flax ones. Fragment indicates that this may have been a portion of a gamma or h shaped motif; if so, this was part of a lightweight cloak or mantle ', NULL, NULL, '2010-01-09', NULL),
(1701059, 152, 'toy ball made of lumps of wool and with plaited outer shell', '5.00', '4.80', '2.00', 1, 'toy', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 'multiple', NULL, NULL, NULL, 'variate', 'NA', NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'multiple', NULL, 'plaited decoration', 'multiple', 'a toy ball, made of lumps of unspun but dyed wool, tied together by criss crossing various wool yarns. Over these criss-crossed yarns a God\'s eye pattern was created, by plaiting wool threads. ', NULL, NULL, '2010-01-09', NULL);
INSERT INTO `textile` (`Textile_ID`, `bucket_id`, `Textile_name`, `Length(cm)`, `Width(cm)`, `Hight(cm)`, `Number_of_fragments`, `Function`, `Functionality1`, `Functionality2`, `Textile_Item_ID1`, `Ground_weave`, `Warp_count`, `Weft_count`, `Perceived_thickness`, `Warp_spin/ply`, `Weft_spin/ply`, `Number_warps`, `Number_wefts`, `Warp_spin_tightness`, `Weft_spin_tightness`, `Warp_spin_angle`, `Weft_spin_angle`, `Warp_diameter(mm)`, `Weft_diameter(mm)`, `Warp_fibre`, `Weft_fibre`, `General_fibre`, `Warp_colour`, `Weft_colour`, `Decoration`, `General_colour`, `Textile_description`, `Date_analyzed`, `Locus_addition`, `Date_excavation`, `migration_note`) VALUES
(1741059, 151, 'red diamond twill textile', '3.50', '3.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'diamond twill', 14, 20, 'NK', 'z', 'z', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'red', 'red', NULL, 'red', 'an exquisite diamond twill textile, possibly from a cloak', NULL, NULL, '2010-01-07', NULL),
(1751059, 154, 'woollen, green textile fragment', '10.00', '3.80', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 16, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'green', NULL, 'green', 'a woollen textile, probably from a garment, of fair quality', NULL, NULL, '2010-01-11', NULL),
(1771059, 150, 'Cotton shawl with checked pattern', '5.00', '4.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 12, 16, 'NK', 'multiple', 'multiple', NULL, NULL, 'variate', 'variate', NULL, NULL, NULL, NULL, 'multiple', 'multiple', 'multiple', 'multiple', 'multiple', 'check pattern', 'multiple', 'fragment f cotton weave, possibly a shawl, in which a check patern was formed with the addition of red wool yarns in both weft and warp; blue background; at a later time the textile was reinforced, by rolling the edge and sewing it with a yellow dubled wool thread, in slanted stitch; it is impossible to tell whether this was the original hem, or whether it is a reinforcement;', NULL, NULL, '2010-01-04', NULL),
(1781059, 153, 'heavy duty cotton textile', '2.50', '2.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 6, 8, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'cotton textile, for household or industrial purpose; coarse; z spun yarns', NULL, NULL, NULL, 'bucket unclear'),
(1791059, 160, 'fragment of coarse woollen weave with yellow stripe', '18.00', '16.00', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'half-basket (2WA/1WE)', 8, 16, 'NK', 's', 's', 2, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'brown', 'a large fragment of coarsewoollen weave, with a yellow stripe in the weft, and a tiny red stripe next to it; sometimes, at irregular intervals, self-banding in the weft, by doubling weft; about 4 shots of red wool weft on the right edge, as seen in pictures', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(1801059, 153, 'Goat hair fragment', '5.20', '2.00', '0.00', 0, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 5, 5, 'NK', 's2z', 's2z', NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'fragment of goat hair with selvedge, unknown function', NULL, NULL, '2010-01-10', NULL),
(1811059, 153, 'Thread fragment with knot', '15.50', '0.90', '0.00', 0, 'tying up', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z2s', NULL, NULL, NULL, 'NK', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of thick thread with a know', NULL, NULL, '2010-01-10', NULL),
(1821059, 153, 'Thread fragment', '7.50', '2.00', '0.00', 0, 'tying up', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z5s', NULL, NULL, NULL, 'NK', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of thread, thick, associated with a small piece of animal fur with skin (goat, rabbit?)', NULL, NULL, '2010-01-10', NULL),
(1831059, 153, 'Sack cloth fragment', '19.50', '5.50', '1.00', 0, 'sack', 'padding fill', 'NK', NULL, 'balanced tabby', 5, 7, 'NK', 'z', 'z', NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of coarse cotton weave, very thick yarn, possibly sack cloth, with mud and dust attached', NULL, NULL, '2010-01-10', NULL),
(1841059, 153, 'Sack cloth fragment', '5.70', '2.80', '1.00', 0, 'sack', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z', 'z', NULL, NULL, 'NK', 'NK', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of thick and coarse cloth, possibly from a sack, with dark red, resin like residue on it; not resin, however, possibly of animal origin', NULL, NULL, '2010-01-10', NULL),
(1851059, 153, 'Wool weave fragment', '5.50', '5.00', '1.00', 0, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 's', 's', NULL, NULL, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'yellow', 'partially unraveled fragment of yellow wool weave, with 2 s2z threads inserted in the weave; associated with a red s2z wool thread', NULL, NULL, '2010-01-10', NULL),
(1861059, 153, 'Wool weave fragment', '5.00', '4.50', '1.00', 0, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 10, 40, 'NK', 's', 's', NULL, NULL, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'partially unraveled wool textile, probably coming initially from a garment; has an s2z wool thread apparently going in to the weave, may have functioned once as a fringe, but it is impossible to tell with any certainty; associated with fragments of TX185 BE10-59.001.PB004', NULL, NULL, '2010-01-10', NULL),
(1871059, 153, 'Wool weave fragment', '21.00', '16.00', '1.00', 0, 'garment', 'tying up', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 's', 's', 6, 12, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', NULL, NULL, NULL, 'brown', 'badly loosened wool textile fragment, sewn down at the corner and re-used for fastening?', NULL, NULL, '2010-01-10', NULL),
(1881059, 153, 'Striped woolen textile', '14.50', '5.50', '2.00', 0, 'shawl', 'padding fill', 'NK', NULL, 'balanced tabby', 9, 12, 'NK', 's', 's', NULL, NULL, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe pattern', 'brown', 'badly damaged woolen textile, a rather open weave, possibly coming from a shawl or another lightweight dress item; structural decoration, by means of red stripes in the weft; each stripe consisting of three wefts, and is positioned once in four other wefts; found mingled with the remains of at least 3 other wool textiles, and a z2s cotton thread.', NULL, NULL, '2010-01-10', NULL),
(1891059, 153, 'Cotton textile fragment', '5.00', '4.50', '0.00', 0, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 8, 10, 'NK', 'z', 'z', NULL, NULL, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'badly damaged piece of cotton weave, probably of industrial or household use', NULL, NULL, '2010-01-10', NULL),
(1901059, 153, 'Cotton cord (tassel?)', '11.00', '1.50', '1.00', 0, 'NK', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z10s', NULL, NULL, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragment of a cotton cord loosened at one of the ends, may have been a tassel, but there is no certainty.', NULL, NULL, '2010-01-10', NULL),
(1911059, 150, 'cotton textile with blue pattern', '11.00', '5.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'basket (2WA/2WE)', 6, 18, 'NK', 's', 's', 2, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', NULL, 'multiple', 'a small cotton tight weave, with blue and ecru yands alternating in both weft and warp, and changing sequence a least once in 12 shots. Because the textile is strongly weft-faced, the appearance is that of small checked patterns', NULL, NULL, '2010-01-04', NULL),
(1921059, 153, 'Cotton texile fragment', '0.70', '0.50', '0.00', 0, 'shawl', 'padding fill', 'NK', NULL, 'balanced tabby', NULL, NULL, 'NK', 'z', 'z', NULL, NULL, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'fine and minute fragment of what appears to be a cotton tabby of red and blue check pattern; red and blue alternate two by two.', NULL, NULL, '2010-01-10', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1931059, 151, 'Cotton textile fragment', '7.50', '2.30', '1.00', 3, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 22, 26, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fine piece of cotton textile, tightly woven and lightweight, possibly from a garment in its function', NULL, NULL, '2010-01-07', 'Zusätzliche Zuordnug zu Bucket 5 (2010-01-11)'),
(1941059, 150, 'Wool cord', '11.00', '0.60', '0.00', 0, 'tying up', 'NK', 'NK', NULL, 'basket (4WA/2WE)', NULL, NULL, 'NK', 's', 's', 4, 2, 'loose', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragment of cord, possibly for tying up other items; made like a selvedge, with doubled weft passing three warp bundles, arranged as 3-4-4 warp bundles.', NULL, NULL, '2010-01-04', NULL),
(1951059, 150, 'Woollen open weave textile', '85.00', '13.00', '0.00', 1, 'shawl', 'padding fill', 'NK', NULL, 'weft-faced tabby', 5, 10, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a lightweight, open weave in wool, similar to that of shawls; found attached to a series of other remains: wood, plant stalks, animal hair and bone; should be seen by other specialists', NULL, NULL, '2010-01-04', NULL),
(1961059, 150, 'Wool garment fragment', '6.00', '1.50', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 10, 10, 'NK', 's', 's', NULL, NULL, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', NULL, 'brown', 'fragment of woollen weave that may have belonged to a germent; has a plaited selvedge; three warp bundles were twined near the simple selvedge, creating a plaited appearance; wool in of yellow colour;', NULL, NULL, '2010-01-04', NULL),
(1971059, 150, 'Flax tow? cord', '8.50', '0.40', '0.00', 1, 'tying up', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'flax tow?', '', 'flax tow?', NULL, NULL, NULL, 'ecru', 'a cord of flax tow? in any case, a very crude fibre;', NULL, NULL, '2010-01-04', NULL),
(1981059, 150, 'wool half-basket weave', '8.50', '5.50', '0.00', 1, 'furnishing', 'padding fill', 'NK', NULL, 'half-basket (4WA/1WE)', 3, 7, 'NK', 's3z', 'multiple', 4, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'multiple', 'multiple', NULL, 'multiple', 'a woollen weave with s3z wefts in red and blue, over which bundles of four warps, each s3z were passed. a warp of green, s3z is inserted to the warp bundle once every second warp', NULL, NULL, '2010-01-04', NULL),
(1991059, 150, 'blue wool textile enmeshed with threads', '10.00', '1.50', '0.00', 0, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 8, 18, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a fragment of textile hem (PB001); fragments of selvedge alone (PB022), and of textile and selvedge (PB35); wool weave, relatively open; associated with various other unraveled blue wool threads, cords, and other decayed textiles; also cotton rope; probably all these functioned together as padding fill', NULL, NULL, '2010-01-04', 'Zusätzliche Zuordnug zu Bucket 2 (2010-01-07)'),
(2001059, 150, 'Wool textile fragment', '25.00', '4.50', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 34, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'three fragments of tightly woven woollen fragment, possibly originally from a farment; slightly cleaned with a micro-usb vacuum cleaner, otherwise left untouched', NULL, NULL, '2010-01-04', NULL),
(2011059, 150, 'Wool textile fragment', '5.00', '0.80', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'NK', 'NK', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a small fragment of badly unraveled textile, the weave is barely observable', NULL, NULL, '2010-01-04', NULL),
(2021059, 150, 'Linen textile', '5.00', '2.70', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 24, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'small fragment of linen textile', NULL, NULL, '2010-01-04', 'Zusätzliche Zuordnug zu Bucket 2 (2010-01-07)'),
(2031059, 150, 'Wool cord', '3.50', '0.70', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a cord of blue wool, made by wraping a tripple weft over 3 bundles of tripled warp.', NULL, NULL, '2010-01-04', NULL),
(2041059, 150, 'wool textile with cord', '2.40', '1.10', '0.00', 2, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 25, 'NK', 's', 's', NULL, NULL, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'yellow', NULL, 'yellow', 'tiny fragment of tightly woven woollen weave, with a beginning or end of cloth that presents a cord.', NULL, NULL, '2010-01-04', NULL),
(2051059, 150, 'wool compound weave', '0.00', '0.00', '0.00', 5, 'furnishing', 'NK', 'NK', NULL, 'weft-faced compound', NULL, NULL, 'NK', 's', 's', NULL, NULL, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', NULL, 'brown', '5 fragments of a compound weave, much decayed, so the pattern cannot be rendered.', NULL, NULL, '2010-01-04', 'Zusätzliche Zuordnug zu Bucket 2 (2010-01-07)'),
(2061059, 150, 'Woollen textile', '7.30', '1.80', '1.00', 2, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 14, 48, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', NULL, 'yellow', 'a small, but finely woven woollen textile; it is the seam that would probably link the two individually woven parts of a tunic, as the seam contains both selvedges. There are fragments of plied threads at one edge, indicating that fringes were pulled out of the cloth; I have no idea from which particular part of the tunic this piece came; a second fragment, from PB002, contains tapestry decoration in blue wool ', NULL, NULL, '2010-01-04', NULL),
(2071059, 150, 'Woollen cord', '9.50', '0.60', '0.00', 5, 'tying up', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragments of woollen cord, made by wrapping triple weft  around 3 bundles of warp, each made of 3 yarns.', NULL, NULL, '2010-01-04', NULL),
(2081059, 150, 'Cotton textile fragment', '8.80', '2.00', '1.00', 4, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 15, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'small fragment of cotton textile, without any indication of usage', NULL, NULL, '2010-01-04', NULL),
(2091059, 150, 'Wool textile with rolled hem', '6.80', '2.50', '1.00', 4, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 24, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '4 fragments of a woollen textile, which was hemmed with a woollwn thred, then repaired on the hem with a flax thread for a second time', NULL, NULL, '2010-01-04', NULL),
(2101059, 150, 'Wool textile fragment', '2.50', '1.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 9, 'NK', 's', 's', NULL, NULL, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'yello', NULL, 'yellow', 'a small fragment of wool weave, weft is different in colour than the warp', NULL, NULL, '2010-01-04', NULL),
(2111059, 150, 'Wool pile textile', '8.40', '3.40', '1.00', 7, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 64, 'NK', 's2z', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fragment of woollen weave; probably from a garment; the weave has had rows of pile, once in 12-16 shots of the weft; pile made by inserting extra wefts of wool, at each 1 or 2 passes of the weft; mpossible to say whether it was looped or not;', NULL, NULL, '2010-01-04', NULL),
(2121059, 150, 'Flax cord', '2.40', '1.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'half-basket (4WA/1WE)', NULL, NULL, 'NK', 's', 's', 4, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'wool', 'multiple', 'ecru', 'ecru', NULL, 'ecru', 'a small fragment of flax cord, made by means of weaving a weft onto 4 bundles of warp yarns, each of 4 warps.', NULL, NULL, '2010-01-04', NULL),
(2131059, 150, 'Cotton textile', '2.50', '2.30', '1.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 18, 30, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a small, tightly woven tragment of cotton', NULL, NULL, '2010-01-04', NULL),
(2141059, 150, 'Cotton textile fragment', '2.50', '2.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 16, 'NK', 'z', 'z', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a small fragment of cotton weave of unknown purpose.', NULL, NULL, '2010-01-04', NULL),
(2151059, 150, 'Woolen garment fragment', '4.00', '3.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 38, 'NK', 's2z', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', 'tapestry', 'ecru', 'a small frament of the bottom portion? of a tunic or a similar garment, with a fragmentary clavus? in red; remains of reinforced selvedge present', NULL, NULL, '2010-01-04', NULL),
(2161059, 150, 'Woolen textile fragment', '10.70', '4.30', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 30, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a fragment of finely woven woollen textile; a surface find, found next to the sieve', NULL, NULL, '2010-01-04', NULL),
(2171059, 159, 'Cotton textile with pile', '7.80', '5.50', '1.00', 1, 'furnishing', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 5, 11, 'NK', 's2z', 's', 1, 2, 'medium', 'loose', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a cotton weave, very coarse, that may have had pile, but nothing more can be said due to the bad preservation', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2181059, 159, 'Flax furnishing textile', '8.40', '6.00', '0.00', 2, 'furnishing', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 5, 14, 'NK', 's2z', 's', 1, 2, 'medium', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'white', 'white', NULL, 'white', 'a fragment of flax furnishing textile with fringed selvedge, that was sewn onto with the sid of a slanting stitch in flax yarn.', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2191059, 151, 'Goat hair sack fragment', '26.00', '7.50', '1.00', 3, 'sack', 'NK', 'NK', NULL, 'balanced tabby', 5, 4, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '3 fragments of a heavy-duty goat hair weave, possibly used in commercial activities such as transportation; probably from a sack; has a hem made with returning stitch in s2z yellow goat hair. Is literally enmeshed with tiny goat hairs, probably they were stored in this textile? also attached to pieces of animal fur and skin ', NULL, NULL, '2010-01-07', NULL),
(2201059, 151, 'Goat hair textile', '9.00', '5.00', '2.00', 2, 'NK', 'padding amalgam', 'NK', NULL, 'weft-faced tabby', 3, 6, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a goat hair textile apparently sewn onto other textiles, forming a (part of) a padding amalgam; there are stitches in s2z yellow and brown goat hair thread attesting to that; preserves a simple selvedge', NULL, NULL, '2010-01-07', NULL),
(2211059, 151, 'Heavy duty wool textile', '26.00', '16.50', '0.00', 2, 'furnishing', 'padding amalgam', 'NK', 1, 'weft-faced tabby', 5, 24, 'NK', 's2z', 's', 1, 1, 'medium', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'brown', NULL, 'brown', 'a heavy duty woollen weave, most probably from a furnishing item or a carpet; was re-used as part of a sewn padding amalgam.', NULL, NULL, '2010-01-07', NULL),
(2221059, 151, 'Wool textile', '8.50', '6.50', '0.00', 1, 'NK', 'padding amalgam', 'NK', 1, 'balanced tabby', 10, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'fragment of woollen textile, unknown initial function, sewn into a padding amalgamafterward', NULL, NULL, '2010-01-07', NULL),
(2231059, 151, 'Goat hair pile furnishing', '30.00', '14.00', '1.00', 1, 'furnishing', 'padding amalgam', 'NK', 1, 'balanced tabby', 3, 3, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'multiple', 'a furnishing (possibly small carpet) piece, of entire width, but unknown original length, with fringes and pile; although the width appears to be complete, as indicated by the fringes, no selvedge or starting/finishing border could be traced; presumably they were never executed.', NULL, NULL, '2010-01-07', NULL),
(2241059, 151, 'Goat hair textile', '15.00', '15.00', '1.00', 1, 'furnishing', 'NK', 'NK', NULL, 'warp-faced tabby', 6, 3, 'NK', 's2z', 's2z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a piece of goat hair, thick fabric, probably part of a furnishing of some sort, or a sack or tent; has remains of stitching of irregular size and position, suggesting that it was probably re-used in a padding amalgam; preserves one selvedge.', NULL, NULL, '2010-01-07', NULL),
(2251059, 159, 'Wool textile fragment', '2.00', '1.50', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 10, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '2 small fragments of woollwn weave;', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2261059, 151, 'Wool textile fragment', '3.70', '1.50', '0.00', 1, 'NK', 'padding amalgam', 'NK', 1, 'balanced tabby', 11, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a tiny fragment of woollen textile, part f a padding amalgam', NULL, NULL, '2010-01-07', NULL),
(2271059, 151, 'Wool textile fragment', '18.00', '15.50', '1.00', 2, 'NK', 'NK', 'NK', NULL, 'half-basket (2WA/1WE)', 6, 22, 'NK', 's', 's', 2, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'multiple', 'multiple', 'stripe', 'yellow', 'a small woollen fragment, with a rolled and sewn hem, slanted stitch; the warp is doubled and alternates 2 brown warps with two blue warps; the sequence cannot be observed with the naked eye due to the weft-faced nature of the weave; the textile seems to have been combed on one side, and posibly shorn; inside the textile the remains of a small animal or seed, dissecated; a second, larger fragment, reveals the sequence of blue and ecru warps: blue was used in pairs 2 warps, then 2 ecru warps, and that only for half of the total warps; half of the textile has entirely ecru warps ', NULL, NULL, '2010-01-07', NULL),
(2281059, 151, 'Wool brown shawl with red stripes', '36.00', '31.50', '0.00', 10, 'shawl', 'padding fill', 'NK', NULL, 'balanced tabby', 8, 10, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'stripe', 'multiple', 'a fragmentary shawl or a wrapping piece, definitely a garment; decoration made of stripes in red wool in the weft; has yellow borders next to the opening and closing edges, which are corded.', NULL, NULL, '2010-01-07', NULL),
(2291059, 151, 'Wool cord', '6.20', '0.60', '0.00', 1, 'tying up', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a small woollen cord made of tripled weft wrapped around 3 bundles of tripled warp', NULL, NULL, '2010-01-07', NULL),
(2301059, 151, 'Cotton textile fragment', '5.50', '2.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 4, 10, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'small and badly damaged cotton textile, of tight yarn spin', NULL, NULL, '2010-01-07', NULL),
(2311059, 151, 'Sheep\'s wool with attached skin', '3.00', '2.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, NULL, 'ecru', 'a piece of sheep\'s wool? with attashed skin, of obviously natural colour', NULL, NULL, '2010-01-07', NULL),
(2321059, 151, 'Sheep\'s wool with attached skin', '4.80', '4.50', '1.00', 3, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, NULL, 'ecru', 'a small fragment of cord, warp is flax, but weft is wool, made by means of weaving a weft onto 4 bundles of warp yarns, each of 4 warps.', NULL, NULL, '2010-01-07', NULL),
(2331059, 151, 'Sheep\'s wool with attached skin', '4.40', '2.00', '0.00', 4, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, '', '', '', NULL, NULL, NULL, 'ecru', 'a piece of sheep\'s brown wool with attached skin, naturally coloured.', NULL, NULL, '2010-01-07', NULL),
(2341059, 160, 'fine cotton textile', '4.00', '0.80', '0.00', 5, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 16, 33, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a fine cotton weave, of exquisite fine yarn', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2351059, 160, 'fine flax textile', '6.50', '3.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 22, 30, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self-banding', 'ecru', 'a fine flax weave, with structural decoration, in the form of self banding (3 warps doubled)', NULL, 'C; West Baulk Trim; also D; North Baulk Trim', '2010-01-16', 'Zusätzliche Zuordnug zu Bucket 12 (2010-01-16)'),
(2361059, 151, 'Open woollen weave', '32.00', '3.30', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 12, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a small open woollen weave, probably used after for padding ', NULL, NULL, '2010-01-07', NULL),
(2371059, 151, 'Wool garment fragment', '17.40', '13.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 8, 10, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'brown', 'a fragment from a probably woollen tunic, with a corded beginning or end of cloth, and a yellow stripe paralel to this feature, made with the addition of yellow wefts. Attached to it was a seed of some sort, possibly of watermelon?', NULL, NULL, '2010-01-07', NULL),
(2381059, 151, 'Wool textile fragment', '6.00', '4.50', '1.00', 2, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 10, 12, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a small piece of woollen weave, probably from a garment.', NULL, NULL, '2010-01-07', NULL),
(2391059, 151, 'Cotton textile fragment', '15.30', '3.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 8, 12, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a coton weave, unknown function', NULL, NULL, '2010-01-07', NULL),
(2401059, 151, 'Flax textile fragment', '3.50', '3.10', '1.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 16, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'small flax textile, of rather crude make, relatively thick, possibly from industrial or household related purposes', NULL, NULL, '2010-01-07', NULL),
(2411059, 151, 'Wool textile', '4.00', '3.50', '1.00', 4, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 10, 18, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'small woollen textile, probably from a garment; one of the fragments attatched to animal hde, decomposing, wooden or plant remains, and fur', NULL, NULL, '2010-01-07', NULL),
(2421059, 151, 'Wool textile with yellow stripe', '4.00', '3.80', '1.00', 2, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 9, 9, 'NK', 's', 's', 1, 1, 'tight', 'variate', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'brown', 'stripe', 'brown', 'a poorly made woollen textile, of various spin tightness in the weft; textile has a form of pairing the wefts, once in 2 warps, which does not appear to be consistent; a lighter hued wool creates the appearance of a yellow stripe in the weft.', NULL, NULL, '2010-01-07', NULL),
(2431059, 151, 'Flax basket weave textile', '6.00', '3.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'basket (2WA/2WE)', 4, 14, 'NK', 's', 's', 2, 2, 'loose', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'flax textile, rather thick and rough, probably transportation or another utilitarian purpose.', NULL, NULL, '2010-01-07', NULL),
(2451059, 151, 'fine wool weave', '5.50', '4.00', '1.00', 2, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 12, 58, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine woollen weave, tightly woven, possibly from a garment;', NULL, NULL, '2010-01-07', NULL),
(2461059, 150, 'fine wool weave', '3.90', '3.30', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 12, 28, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yelllow', 'yellow', NULL, 'yellow', '', NULL, NULL, '2010-01-04', NULL),
(2471059, 151, 'fine wool weave', '7.50', '2.20', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 13, 50, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'tapestry', 'yellow', 'a fine wool weave, which has the decomposed remains of a tapestry attached; only the blue yarn survives', NULL, NULL, '2010-01-07', NULL),
(2481059, 151, 'fine wool weave', '4.90', '2.30', '0.00', 4, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 36, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine wool weave', NULL, NULL, '2010-01-07', NULL),
(2491059, 151, 'fine wool weave', '7.50', '5.20', '0.00', 5, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 32, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine wool textile, with corded end of cloth, then reinforced with overcast stitching', NULL, NULL, '2010-01-07', 'Zusätzliche Zuordnug zu Bucket 10 (2010-01-14)'),
(2501059, 151, 'wool weave with blue stripe', '4.20', '1.70', '0.00', 6, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 18, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'brown', 'woollen weave with a stripe in the weft, bluw wool threads, 25 shots; a \"knob or button\"\" is made of a cord from this textile; unknown function\"', NULL, NULL, '2010-01-07', NULL),
(2511059, 151, 'wool weave with blue and yellow yarns spun together', '14.00', '0.40', '1.00', 2, 'NK', 'tying up', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'the hem area of a woollen textile, in which ecru and blue wool yarns were spun together; overall, the impression is that the textile is sky blue; hem sewn in s2s2z wool yarn of the same composition', NULL, NULL, '2010-01-07', NULL),
(2521059, 151, 'cotton textile', '8.50', '2.80', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 32, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'cotton textile nicely wove, no features', NULL, NULL, '2010-01-07', NULL),
(2531059, 160, 'fragments of a cloak with h-shaped motif', '16.00', '11.50', '0.00', 7, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 20, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'tapestry', 'yellow', 'a cloak or overgarment with a gamma or a h-shaped motif in tapestry weave; found together with the remnants of a plaited cord; it is not apparent how the two would have been connected.', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2541059, 151, 'wool textile', '5.50', '1.20', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a small yellow wool weave', NULL, NULL, '2010-01-07', NULL),
(2551059, 151, 'wool textile', '4.50', '2.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 6, 8, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'brown', NULL, 'brown', 'a small woollen weave, with slightly different coloured warps and wefts.', NULL, NULL, '2010-01-07', NULL),
(2561059, 151, 'wool textile', '5.00', '2.70', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 12, 14, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a small yellow woollen textile, no features', NULL, NULL, '2010-01-07', NULL),
(2571059, 160, 'heavy duty cotton textile', '2.50', '2.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 13, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a heavy duty cotton textile, whose yarns are almost like flax;', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2581059, 151, 'wool textile', '4.00', '0.50', '0.00', 1, 'NK', 'tying up', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a part of a hem, stitched in s2z wool,  overcast stitch', NULL, NULL, '2010-01-07', NULL),
(2591059, 151, 'cotton textile', '2.70', '2.40', '2.00', 2, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 12, 12, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a cotton textile crumped together; no visible features', NULL, NULL, '2010-01-07', NULL),
(2601059, 151, 'coton tassel', '7.70', '0.90', '1.00', 1, 'tassel', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', NULL, NULL, NULL, 'tight', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'a cord made of multiple cotton threads; may have been a former tassel', NULL, NULL, '2010-01-07', NULL),
(2611059, 151, 'wool textile', '2.00', '1.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 22, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a crumpled wool textile', NULL, NULL, '2010-01-07', NULL),
(2621059, 152, 'goat hair furnishing', '9.00', '5.00', '2.00', 3, 'furnishing', 'NK', 'NK', NULL, 'balanced tabby', 3, 4, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'an interesting piece: very thick and sturdy, must have come from a tent/ saddle/ matting, sacking; apparently a selvedge or corded end of cloth never existed; on one of the edges, probably to prevent unraveling and to reinforce the weave, a cord was sewn; the sewing enters the cloth for 2 running stitches, and returns into the cord.', NULL, NULL, '2010-01-09', NULL),
(2631059, 152, 'goat hair furnishing', '15.00', '7.50', '0.00', 1, 'furnishing', 'padding amalgam', 'NK', 2, 'weft-faced tabby', 4, 14, 'NK', 'z2s', 'z2s', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'multiple', 'stripe', 'brown', 'a goat-hair weave, sturdy and thick, probably used for tenting, matting, orsacking; at one edge, the weft is yellow, forming a stripe in the weave; the weave is also interesting because the yarns are spun in z direction; the weave is sewn to TX264 probably part of a padding amalgam', NULL, NULL, '2010-01-09', NULL),
(2641059, 152, 'goat hair furnishing', '21.00', '8.20', '1.00', 4, 'furnishing', 'padding amalgam', 'NK', 2, 'balanced tabby', 4, 5, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a neatly made goat hair weave, sturdy and thick, made probably for transportation or furnishing; it has a hem, made probably by rolling two pieces of the same textile; found attached to a goat hair and skin piece', NULL, NULL, '2010-01-09', NULL),
(2651059, 152, 'goat hair furnishing', '4.50', '4.00', '0.00', 2, 'furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 2, 6, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'small fragment of goat hair weave, with selvedge preserved', NULL, NULL, '2010-01-09', NULL),
(2661059, 152, 'goat hair furnishing', '6.90', '3.00', '0.00', 3, 'furnishing', 'NK', 'NK', NULL, 'balanced tabby', 4, 5, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '3 fragments of a furnishing goat hair weave, with stitching on them', NULL, NULL, '2010-01-09', NULL),
(2671059, 152, 'goat hair lump', '6.00', '3.50', '1.00', 3, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'goat hair', '', 'goat hair', 'brown', NULL, NULL, 'brown', '3 lumps of unspun goat hair, meshed together with threads of wool and remains of a decomposed woollen textile? in lighter brown; probably used for filling/padding?', NULL, NULL, '2010-01-09', NULL),
(2681059, 152, 'woollen weave', '5.40', '2.80', '1.00', 1, 'garment', 'padding fill', 'NK', NULL, 'weft-faced tabby', 7, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a brown woollen weace neatly rolled and tied, probably used as padding', NULL, '', '2010-01-09', NULL),
(2691059, 152, 'cotton weave', '6.00', '4.50', '1.00', 3, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 20, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragments of decomposed cotton weave', NULL, NULL, '2010-01-09', NULL),
(2701059, 152, 'woollen weave', '14.50', '3.00', '1.00', 6, 'NK', 'tying up', 'NK', NULL, 'weft-faced tabby', 7, 13, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', 'a heavy duty woollen weave, probably of industrial or household use; there is a seam made by rolling inside two sides of the cloth; it appears that this was created at the same time the textile was sewn for reinforcement purposes, maybe to help tying up something?', NULL, NULL, '2010-01-09', NULL),
(2711059, 152, 'cotton weave', '7.30', '2.00', '1.00', 3, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 16, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a cotton weave without structural features', NULL, NULL, '2010-01-09', 'Zusätzliche Zuordnug zu Bucket 4 (2010-01-10)'),
(2721059, 159, 'flax weave', '2.50', '1.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 5, 25, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a small fragment of flax weave', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2731059, 159, 'woollen weave', '12.00', '4.50', '1.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 19, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'woolen textile, probably from a garment; a seam made by folding two edges of the cloth into one another was made: slanting stitch, one in s2z brown wool, the other in a quadrupled z-spun goat or woollen thread.', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2741059, 159, 'goat hair textile', '4.40', '1.70', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 4, 8, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a goat hair weave, in which two edges of cloth have been sewn together apparently as to form a hem; threads of yellow and red wool appear to have been used in the sewing as well, besides the 2 threads of s2z goat hair each', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2761059, 159, '2 lumps of much mingled and decayed weaves', '3.50', '3.20', '1.00', 2, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', NULL, NULL, 'yellow', '2 lumps of what appeared to be unspun wool; on closer analysis, he vague contour of a former, much decayed weave, can be observed', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2771059, 159, 'woollen textile fragment', '6.00', '4.00', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 10, 14, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a woollen weave', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2781059, 159, 'woollen textile with selvedge', '3.00', '2.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 12, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a woollen textile, coarse and thick, with a reinforced selvedge', NULL, 'B; South Baulk Trim', '2010-01-14', NULL),
(2791059, 160, 'flax textile', '4.00', '2.40', '1.00', 12, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 12, 19, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'closely woven flax weave', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2801059, 160, 'goat hair textile', '4.50', '3.30', '0.00', 3, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 4, 8, 'NK', 's2z', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'multiple', NULL, 'brown', 'an interesting goat hair weave; for a certain span, brown and yellow goat hair wefts run interchageably, then 4 shots of weft are fully yellow, leaving the rest of the textile with brown wefts alone; this may have created a larger checked pattern', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2811059, 160, 'open woven woollen textile', '4.00', '2.00', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 9, 13, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a relatively open weave woollen textile', NULL, 'C; West Baulk Trim; also D; North Baulk Trim', '2010-01-16', 'Zusätzliche Zuordnug zu Bucket 12 (2010-01-16)'),
(2821059, 160, 'fragment of unraveled cotton cord', '5.00', '0.70', '1.00', 2, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z', NULL, NULL, NULL, 'tight', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'remains of a cotton cord', NULL, 'C; West Baulk Trim', '2010-01-16', NULL),
(2831059, 161, 'fragment of rope', '10.00', '4.00', '1.00', 1, 'tying up', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z', NULL, NULL, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'NK', '', 'NK', 'ecru', NULL, NULL, 'ecru', 'a fragment of rope of unknown fibre', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2841059, 161, 'fragment of leather cord', '2.50', '1.20', '1.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'leather', '', 'leather', NULL, NULL, NULL, 'brown', 'a fragment of what appears to be a leather cord, or the twisted edge of a leather object.', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2851059, 161, 'fragment of selvedge from blue textile', '2.00', '1.70', '0.00', 2, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', NULL, NULL, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a fragment of selvedge from a blue textile, reinforced over 3 warp bundles, each of 2 warps, with a supplementary, double wrapping weft; remains of threads together with the fragment; possibly related to TX199', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2861059, 161, 'fragment of yellow woollen shawl?', '31.50', '7.00', '1.00', 3, 'shawl', 'tying up', 'NK', NULL, 'balanced tabby', 7, 9, 'NK', 's', 's', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', ' an open weave, maybe from a shawl, used then for tying up; the textile was used for fastening, as the torsion indicates', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2871059, 161, 'a pile of coloured threads from textiles', '7.00', '5.00', '2.00', 0, 'NK', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', NULL, NULL, NULL, NULL, 'NA', 'NA', NULL, NULL, NULL, NULL, 'multiple', '', 'multiple', 'multiple', NULL, NULL, 'multiple', 'a pile of threads formerly used in textiles, now loose', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2881059, 161, 'fragment of flax basket weave', '3.00', '2.50', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'basket (2WA/2WE)', 6, 13, 'NK', 's', 's', 2, 2, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a fragment of basket weave; in obe of the edges wefts pass 3 warp bundles of 5 warps each, which may have been a form of self banding; simple selvedge present', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2891059, 161, 'a cord woven in basket weave, then plaited', '2.20', '0.90', '0.00', 1, 'tying up', 'NK', 'NK', NULL, 'basket (3WA/3WE)', NULL, NULL, 'NK', 's', 's', 3, 3, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', NULL, NULL, 'brown', 'a cord ,  which was plaited for whatever purpose', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2901059, 161, 'fragment of woollen diamond twill', '2.00', '1.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'diamond twill', 10, 20, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine twill weave, with green threads in a pile? a doubled weft in wool, S-spun, is inseted every 2 warps, on the length of 2 warps', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2911059, 161, 'fragment of green woollen weave with yellow threads', '2.00', '1.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'green', 'multiple', NULL, 'green', 'a small fragment of green woollen weave, with three wefts of yellow wool', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2921059, 161, 'fragment of flax tow cord?', '2.50', '0.50', '1.00', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, 'NK', 's2z', NULL, NULL, NULL, 'medium', 'NA', NULL, NULL, NULL, NULL, 'flax tow?', '', 'flax tow?', 'ecru', NULL, NULL, 'ecru', ' a fragment of cord, unknown raw material, maybe tow', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2931059, 161, 'fragment of blue shawl?', '5.50', '2.50', '1.00', 1, 'shawl', 'NK', 'NK', NULL, 'balanced tabby', 9, 10, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'a fagment of a relatively open weave, does not seem to be connected with any pther blue textile (TX127, for example), but one may not exclude that.', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2941059, 161, 'fragments of woollen weave', '10.00', '2.70', '0.00', 2, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 20, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'fine woollen weave, so structural feature', NULL, 'D; North Baulk Trim', '2010-01-16', NULL);
INSERT INTO `textile` (`Textile_ID`, `bucket_id`, `Textile_name`, `Length(cm)`, `Width(cm)`, `Hight(cm)`, `Number_of_fragments`, `Function`, `Functionality1`, `Functionality2`, `Textile_Item_ID1`, `Ground_weave`, `Warp_count`, `Weft_count`, `Perceived_thickness`, `Warp_spin/ply`, `Weft_spin/ply`, `Number_warps`, `Number_wefts`, `Warp_spin_tightness`, `Weft_spin_tightness`, `Warp_spin_angle`, `Weft_spin_angle`, `Warp_diameter(mm)`, `Weft_diameter(mm)`, `Warp_fibre`, `Weft_fibre`, `General_fibre`, `Warp_colour`, `Weft_colour`, `Decoration`, `General_colour`, `Textile_description`, `Date_analyzed`, `Locus_addition`, `Date_excavation`, `migration_note`) VALUES
(2951059, 161, 'fragment of flax weavr', '3.70', '3.20', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 11, 36, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a fragment of tightly woven flax weave', NULL, 'D; North Baulk Trim', '2010-01-16', 'Zusätzliche Zuordnug zu Bucket 14 (2010-01-16)'),
(2961059, 161, 'very fine wool tapestry in dark blue', '10.50', '5.00', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 9, 56, 'NK', 's', 's', 4, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'flax', 'multiple', 'flax', 'ecru', 'blue', 'tapestry', 'purple', 'a fine fragment of purple tapestry; best fragment from trench 59; has 4 warp yarns bundled; remains of a small portion of ground weave entirely in flax remain, though it is not possible to reconstruct any of the technical details', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2971059, 161, 'fragment of open woollen weave', '9.00', '8.00', '1.00', 1, 'shawl', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 22, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a fragment of open woollen weave, reinforced selvedge present; reiforced over 2 bundles of warps, each of 4 warps.', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2981059, 161, 'yellow woollen weave', '4.70', '2.00', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 12, 13, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(2991059, 161, 'fragment of woollen weave', '3.00', '2.50', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 16, 26, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', 'a small and neatly woven woollen textile', NULL, 'D; North Baulk Trim', '2010-01-16', NULL),
(3001059, 153, 'tiny fragment of woollen weave in blue', '1.00', '0.50', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 11, 24, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'blue', NULL, 'blue', 'tiny fragment of blue woollen textile', NULL, NULL, '2010-01-10', NULL),
(3011059, 163, 'fragment of heavy duty cotton textile', '21.00', '4.50', '1.00', 3, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 7, 18, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'heavy duty textile of cotton ', NULL, NULL, '2010-01-16', 'Zusätzliche Zuordnug zu Bucket 15 (2010-01-17)'),
(3021059, 163, 'fragments of cotton heavy duty textile', '9.00', '3.80', '1.00', 6, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 14, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragments of a heavy duty cotton textile, with reinforced selvedge preserved; probably of household or industrial purpose', NULL, NULL, '2010-01-16', NULL),
(3031059, 163, 'fragment of flax weave', '3.00', '0.80', '1.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 14, 40, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a minute fragment of tightly eoven flax textile', NULL, NULL, '2010-01-16', NULL),
(3041059, 163, 'fragment of much degraded flax textile', '5.50', '1.80', '1.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 7, 20, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', NULL, 'ecru', 'ecru', 'e very degraded flax textile, almost impossible to say whether it is flax or cotton', NULL, NULL, '2010-01-16', NULL),
(3051059, 163, 'fragment of half-basket cotton textile', '3.00', '2.50', '1.00', 1, 'NK', 'padding fill', 'NK', NULL, 'half-basket (1WA/2WE)', 8, 10, 'NK', 's', 's', 1, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a half-basket cotton textile', NULL, NULL, '2010-01-16', NULL),
(3061059, 164, 'fragments of cotton weave', '6.00', '1.70', '1.00', 6, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 16, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragments of a featureless cotton textile', NULL, NULL, '2010-01-17', 'Zusätzliche Zuordnug zu Bucket 16 (2010-01-18)'),
(3071059, 165, 'heavy duty cotton textile', '4.50', '3.00', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 14, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a heavy duty cotton textile, no structural features.', NULL, NULL, '2010-01-18', NULL),
(3081059, 165, 'heavy duty cotton textile in basket weave', '13.00', '2.00', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'basket (2WA/2WE)', 5, 6, 'NK', 's', 's', 2, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a heavy duty textile in cotton, basket weave', NULL, NULL, '2010-01-18', NULL),
(3091059, 165, 'cotton textile', '3.00', '1.30', '0.00', 2, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 15, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-18', NULL),
(3101059, 165, 'fragment of flax textile', '2.00', '0.70', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 16, 17, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-18', NULL),
(3111059, 165, 'fragment of heavy-duty goat hair weave', '6.00', '5.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 4, 5, 'NK', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', '', NULL, NULL, '2010-01-18', NULL),
(3121059, 165, 'fragments of cotton textile with pile', '8.00', '5.00', '0.00', 6, 'NK', 'padding fill', 'NK', NULL, 'half-basket', 11, 9, 'NK', 's', 's', 1, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'fragments of a cotton textile with an interesting succession of wefts 1-2-1-pile 4 wefts - 1-2-1 and so on', NULL, NULL, '2010-01-18', NULL),
(3131059, 166, 'fragment of cotton textile', '12.00', '6.70', '2.00', 1, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 9, 13, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', NULL),
(3141059, 166, 'fragments of cotton textile', '12.00', '7.00', '1.00', 2, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 7, 12, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', NULL),
(3151059, 166, 'fragments of fine flax textile', '4.00', '0.60', '1.00', 6, 'NK', 'tying up', 'padding fill', NULL, 'weft-faced tabby', 18, 32, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', 'Zusätzliche Zuordnug zu Bucket 18 (2010-01-20)'),
(3161059, 166, 'fragment of much decomposed cotton weave', '0.00', '0.00', '0.00', 2, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 10, 34, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', NULL),
(3171059, 166, 'fragment of featureless cotton textile', '4.50', '2.40', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 28, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton ', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', NULL),
(3181059, 166, 'fragment of unraveled cotton textile', '9.00', '1.00', '0.00', 2, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 14, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'white', 'white', NULL, 'white', '', NULL, NULL, '2010-01-19', NULL),
(3191059, 166, 'fragment of decayed cotton textile', '5.00', '2.90', '1.00', 1, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 10, 11, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-19', NULL),
(3201059, 167, 'fragment of cotton textile with selvedge', '10.00', '2.30', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 8, 13, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'reinforced selvedge preserved', NULL, NULL, '2010-01-20', NULL),
(3211059, 167, 'cotton tassel', '6.50', '2.00', '1.00', 1, 'tassel', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 'z', NULL, NULL, NULL, 'tight', 'NA', NULL, NULL, NULL, NULL, 'cotton', '', 'cotton', 'ecru', NULL, NULL, 'ecru', 'a cotton tassel, unknown function', NULL, NULL, '2010-01-20', NULL),
(3221059, 167, 'fragment of heavy duty cotton textile', '3.00', '3.00', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 6, 10, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-20', NULL),
(3231059, 167, 'fragment of heavy duty cotton textile', '3.00', '2.40', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 8, 10, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, '2010-01-20', NULL),
(3241059, 167, 'fragment of flax weave', '3.80', '1.10', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 9, 38, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', NULL, 'ecru', 'ecru', '', NULL, NULL, '2010-01-20', NULL),
(3251059, 168, 'fragments of exquisite diamond twill weave', '6.00', '3.70', '0.00', 3, 'garment', 'padding fill', 'NK', NULL, 'diamond twill', 27, 31, 'NK', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'fine and light-weight flax weave, of exceptional quality, diamond twill', NULL, '2 frags; one from PB019; the other from PB 022, 2B, South Baulk Trim', '2010-01-21', 'Zusätzliche Zuordnug zu Bucket 22 (2010-01-23)'),
(3261059, 163, 'fagment of cotton woved selvedge', '2.30', '0.70', '0.00', 1, 'NK', 'padding fill', 'NK', NULL, NULL, NULL, NULL, 'NK', 's', 's', NULL, NULL, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'due to the fragmentary state, it is impossible to be sure whether this is a selvedge or a cord; each bundle of warps is made of 4 threads', NULL, NULL, '2010-01-16', NULL),
(3271059, 168, 'fragment of cotton cord', '4.50', '1.70', '0.00', 2, 'NK', 'padding fill', 'NK', NULL, 'basket (3WA/2WE)', NULL, NULL, 'NK', 's', 's', 3, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'remains of a cotton cord;', NULL, NULL, '2010-01-21', NULL),
(3281059, 168, 'fragment of fine flax weave with coloured stripes', '5.90', '2.50', '1.00', 2, 'furnishing', 'padding fill', 'NK', NULL, 'warp-faced tabby', 52, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'multiple', 'multiple', 'ecru', 'multiple', 'stripe', 'ecru', 'fine flax weave, with 4 stripes in the weft, made in wool; the wool has almost completely dissapeared, but enough exists as to reconstruct how the stripes were made: blue-red-blue-red; paired wefts of wool; simple selvedge survives', NULL, NULL, '2010-01-21', NULL),
(3291059, 169, 'fragments of self-banded cotton textile', '8.50', '2.50', '0.00', 8, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 10, 24, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'self-banding', 'ecru', 'fragments of much decayed cotton textile, with self-banding: 2 rows of tripled warp, consisting 4 bundles each; the two rows are situated at 4 weft shots distance; remains of a seam in s3z flax, running stitch; a third lump of the same textile found in PB0025', NULL, 'multiple frags, PB020 and PB025; locus 2A, East Baulk Trim, PB021', '2010-01-23', 'Zusätzliche Zuordnug zu Bucket 21 (2010-01-23) und 25'),
(3301059, 171, 'fragment of cotton textile', '6.50', '3.00', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 14, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3311059, 171, 'fragment of cotton textile dyed in one piece', '1.70', '1.40', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'tabby', NULL, NULL, 'NK', 'z', 'z', 1, 1, 'NK', 'NK', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'blue', 'blue', NULL, 'blue', 'fragment of cotton textile dyed in one piece', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3321059, 171, 'fragments of cotton checked textile', '7.00', '3.00', '0.00', 3, 'NK', 'padding fill', 'NK', NULL, 'weft-faced tabby', 10, 30, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'check pattern', 'multiple', 'fragments of cotton textile with checked pattern, does not match with any of the other checked textiles', NULL, 'B; South Baulk Trim', '2010-01-23', 'Zusätzliche Zuordnung zu Locus 1 und Bucket 18 (2010-01-20)'),
(3331059, 171, 'fragments of yellow wool weave', '15.00', '3.20', '0.00', 3, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 16, 12, 'NK', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3341059, 171, 'fragment of damaged cotton half-basket', '2.50', '2.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 12, 8, 'NK', 's', 's', 1, 2, 'tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3351059, 171, 'fragment of decayed flax textile', '2.50', '1.50', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 18, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3361059, 171, 'fragment of brown woollen textile', '2.50', '1.70', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 42, 'NK', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3371059, 171, 'fragment of cotton textile', '3.00', '2.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 15, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, 'B; South Baulk Trim', '2010-01-23', NULL),
(3381059, 173, 'fragments of much damaged cotton textile', '11.00', '3.00', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 7, 10, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a heavy duty textile', NULL, 'D; North Baulk Trim', '2010-01-24', NULL),
(3391059, 174, 'fragment of tightly woven cotton textile', '6.00', '2.20', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 14, 28, 'NK', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', '', NULL, NULL, NULL, NULL),
(3401059, 175, 'fragment of fine wool weave', '3.40', '2.10', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 11, 50, 'NK', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '', NULL, NULL, NULL, NULL),
(3411059, 150, 'fragment of thick wool weave with blue stripe', '7.00', '5.80', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 6, 7, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'orange', 'multiple', 'stripe', 'orange', 'a fragment of coarse woollen weave with a blue stripe', NULL, 'surface find, PB001', '2010-01-04', NULL),
(3421059, 184, 'fragment of woollen cloth, rolled and tied', '5.50', '2.70', '1.00', 1, 'NK', 'padding fill', 'NK', NULL, 'balanced tabby', 9, 9, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'yellow', NULL, 'brown', 'thick wool textile, the wefts and warps vary slightly in colour; the warps were made by spinning wool of two different shades together: yellow and brown; textile was folded and neatly wrapped with woollen thread, brown, S spun', NULL, 'A; East Baulk Trim', NULL, NULL),
(3431059, 184, 'fragment of woollen shawl? with red stripe', '7.50', '3.20', '1.00', 1, 'shawl', 'NK', 'NK', NULL, 'balanced tabby', 13, 10, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'brown', 'woollen shawel? with a red stripe, worth 5 weft shots, in the vicinity of the corded end/beginning of cloth; the cloth end was corded, warps get fed in the cord, two by  two.', NULL, 'A; East Baulk Trim', NULL, NULL),
(3441059, 184, 'fragment of brown woollen weave', '5.00', '3.30', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 13, 13, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '', NULL, 'A; East Baulk Trim', NULL, NULL),
(3451059, 184, 'fragment of flax weave with self banding', '3.00', '2.50', '1.00', 1, 'NK', 'NK', 'NK', NULL, 'weft-faced tabby', 10, 22, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self-banding', 'ecru', 'a small piece of frax weave, with self banding, by gathering 2-3 yarns of warps.', NULL, '?', NULL, 'bucket unclear'),
(3461059, 184, 'fragment of flax weave', '2.80', '1.60', '0.00', 1, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 10, 14, 'NK', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', '', NULL, '?', NULL, 'bucket unclear'),
(3471059, 187, 'fragments of cotton weave with \"pile\"', '6.00', '2.30', '1.00', 11, 'NK', 'NK', 'NK', NULL, 'balanced tabby', 11, 9, 'NK', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'pile', 'ecru', 'an interesting cotton textile with a sequence of \"pile\"\"; at a spa of 3 yarns', NULL, 'C; West Baulk Trim', NULL, NULL),
(100180111, 2862, 'fragment of cotton weave part of a sack?', '6.00', '4.50', '0.60', 1, 'household/industrial', NULL, NULL, 6, 'balanced tabby', 10, 6, 'medium-thick', 'z', 'z', 1, 1, 'loose-medium', 'loose', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', '', 'ecru', 'a heavy-duty, coarse cotton textile part of a household item, possibly a sack or another type of item that would be used for storage; the piece was sewn onto another cotton piece to form a storing? item. Traces of multiple types of stitching are present; the item is in an advanced state og degradation', '2025-02-01', NULL, '2018-01-16', NULL),
(100180114, 3029, 'fragment of brown wool weave', '7.00', '2.80', '0.00', 1, 'garment', 'NK', 'NK', NULL, 'balanced tabby', 10, 10, 'thin', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a thin, rather openweave wool weave, fit for a shawl; the fiber is relatively coarse and low quality. no other features. next to it a small piece of animal fur with skin; the piece was dampened on the creases and shaped flat; no other treatment', '2025-02-01', 'SGR (Sidney, a canadian guy that dug the trench), lives in AZ', '2018-01-09', NULL),
(100180118, 2838, 'fragment of wool weave with selvedge', '4.00', '1.40', '0.30', 1, 'garment', 'NK', 'NK', NULL, 'warp-faced tabby', 24, 11, 'thin-medium', 's', 's', 1, 1, 'tensioned', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', 'a medium-coarse wool weave with a reinforced selvedge, possibly from a garment; the thread count is not secure dur to the fragmentary state, and therefore the assessment of the warp faced feature; the warp threads are heavily spun creating the caracteristic tension in the thread; the piece was packed as it was.', '2025-02-01', NULL, '2018-01-13', NULL),
(100190120, 4913, 'frogment of coarse brown wool weave', '3.70', '3.00', '0.10', 1, 'household/garment', NULL, NULL, NULL, 'weft-faced tabby', 5, 11, 'thick', 's', 's', 1, 1, 'very tight', 'very tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', '', 'brown', 'a coarse and thick brown wool weave, with equally tight spun wefts and warps; packed as it was. ', '2025-02-03', NULL, '2019-01-19', NULL),
(100190122, 4918, 'fragment of goat hair weave', '6.00', '5.00', '0.50', 1, 'tent/carpet', NULL, NULL, NULL, 'weft-faced tabby', 3, 7, 'very thick', 's2z', 's2z', 1, 1, 'loose', 'loose-medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a very coarse, closely woven goat hair weave, probably a tent, or mat', '2025-02-05', NULL, '2019-01-09', NULL),
(200180111, 2862, 'fragment of cotton weave part of a sack?', NULL, NULL, NULL, 1, 'household/industrial', NULL, NULL, 6, 'warp-faced tabby', 14, 7, 'medium', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a second cotton fragment belonging to a larger item potentially used for storage in the household, textile item 6; it was sewn together with  TX 100180111, multiple traces of sewing present, advanced state of degradation; the warp and weft are inferred, given the lack of diagnostic features. Presence of seam with s2z flax thread apparently between two edges of the same textile; piece was gently cleaned with a brush by removing dust and soil', '2025-02-02', NULL, '2018-01-16', NULL),
(200180114, 3127, 'fragment of brown wool weave', '6.50', '1.50', '0.30', 1, 'garment', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 22, 'thin-medium', 's', 's', 1, 1, 'tight', 'no spin (I)', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a simple wool weave in brown, likely undyed, with tightly spun presumably warp and weft with almost no spin at all; accompanied by an unspun wool piece in blue color, now much decayed to green, and other remains of cordage; piece packed as it was', '2025-02-02', 'SGR (Sidney)', '2018-01-11', NULL),
(200190120, 4913, 'fragment of plain balanced tabby in cotton', '14.00', '10.00', NULL, 1, 'garmetn/household', NULL, NULL, NULL, 'balanced tabby', 14, 18, 'very thin', 'z', 'z', 1, 1, 'tight', 'medium-tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a thin balanced tabby cotton weave, with the threads in one system, presumably the warp, much more finely spun than in the other system; alternating thinner and more thick threads in the other system, presumably the weft; packed as it was, due to lack of time. ', '2025-02-03', NULL, '2019-01-19', NULL),
(200190122, 4918, 'fragment of brown goat hair weave', '4.00', '3.00', '0.30', 1, 'tent/mat', NULL, NULL, NULL, 'weft-faced tabby', 3, 6, 'very thick', 's2z', 's2z', 1, 1, 'loose', 'loose-medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', '', 'brown', 'small goat hair weave fragment, probably from a tent or mat. Gently de-soiled with a brush and a mini vacuum cleaner and packed', '2025-02-05', NULL, '2019-01-09', NULL),
(300180111, 3000, 'pile of ecru and blue cotton yarns', '4.00', '3.00', '0.30', 1, 'NK', 'NK', 'NK', NULL, NULL, NULL, NULL, NULL, 'z', NULL, NULL, NULL, 'medium', NULL, NULL, NULL, NULL, NULL, 'cotton', NULL, 'cotton', 'ecru', NULL, NULL, 'ecru', 'a pile of mingled cotton threads, mostly ecru and a few discolored blue, does not seem to have ever been a weave; packed as it was; this textile comes from the first season of excavation at the Isis templle, 2015, and the complete labelling is trench 111A; they fiished tranch 111 in 2018', '2025-02-02', '111A, more precisely', '2015-01-27', 'Vorgefundene Textile_ID 300150111 sollte von der vorgefundenen Zuordnung zu Trench und Season 300180111 lauten.'),
(300180114, 3012, 'fragment of half basket yellow wool weave', '11.00', '2.30', '0.00', 1, 'garment/furnishing', 'NK', 'NK', NULL, 'half-basket (1WA/2WE)', 7, 11, 'medium-thick', 'z', 'z', 1, 2, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'gently removed the soil and dust with a brush, then with a mini usb vacuum cleaner; I dampened the corners and shaped the piece flat; relatively thick half basket weave in yellow wool.', '2025-02-02', 'SGR Sidney', '2018-01-13', NULL),
(300190120, 4913, 'fragment of light brown wool weave with bone fragment', '2.50', '2.50', NULL, 1, 'garment/household', NULL, NULL, NULL, 'balanced tabby', 13, 10, 'thin', 's', 's', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a thin balanced tabby wool , featureless, with bone adhering to the surface. Packed as it is. ', '2025-02-03', NULL, '2019-01-19', NULL),
(300190122, 4918, 'fragment of goat hair weave with stitching', '2.80', '1.80', '1.30', 1, 'tent', NULL, NULL, NULL, 'balanced tabby', 6, 6, 'very thick', 's2z', 's2z', 1, 1, 'loose-medium', 'loose-medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'small fragment of the corner of a textile item, perhaps a tent? the corner was secured with a thick and sturdy backstitch executed in a coarse s2z goat hair yarn;. Lightly brushed for de-soiling and packed', '2025-02-05', NULL, '2019-01-09', NULL),
(400180114, 3012, 'fragment of coarse cotton weave', '2.80', '1.50', '0.20', 1, 'household/industrial', 'NK', 'NK', NULL, 'weft-faced tabby', 6, 15, 'medium-thick', 'z', 'z', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a coarse ecru weave in cotton, Z spun, very degraded. ', '2025-02-02', 'SGR Sidney', '2018-01-13', NULL),
(400190120, 4913, 'fragment of brown wool weave', '2.50', '1.50', NULL, 1, 'garment/household', NULL, NULL, NULL, 'balanced tabby', 9, 9, 'thin-medium', 's', 's', 1, 1, 'tensioned', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a thin-medium brown wool weave, featureless; notably the threads in one system and hardly spun. Packed as it was', '2025-02-03', NULL, '2019-01-19', NULL),
(400190122, 4918, 'fragment of unraveled red wool thread', '1.50', '1.50', '0.40', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, NULL, 'red', NULL, NULL, 'red', 'unraveled red wool thread', '2025-02-05', NULL, NULL, 'bucket unclear'),
(500180114, 3126, 'fragment of brown weave with red bands', '12.50', '4.00', '0.20', 1, 'garment/furnishing', 'NK', 'NK', NULL, 'weft-faced tabby', 8, 16, 'medium-thick', 's', 's', 1, 1, 'medium', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'multiple', 'stripe', 'multiple', 'a rather thick wool weave in brown wool with 3 red stripes in the weft? 3 red stripes are preserved, the only one entire preserved has 12 wefts, the others are incomplete; the width of the complete one is aprox 1 cm; This piece would have likely been used as an overgarment, or furnishing; a second fragment of the same textile was found in BE19-120 003 pb 006; the second fragment is badly decayed, crumbled, folded, and had a piece of animal hair with skin adhering to it; also, the second fragment preserves a more thick red band of aprox.  43 wefts, and c. 2.5cm in width, showing that bands of unequal width were used in the cloth;  the conservation treatment was de-dusting with a brush and a vacuum cleaner, and relaxing the creases with water and then laying it flat; I removed the excess moisture with a paper towel.', '2025-02-02', NULL, '2019-01-13', 'Doppelzuordnung zu Trench 114 und 120. Zuordnung zu Trench 120 aufgrund der Textile_ID aufgehoben; zusätzliche Zuordnung zu Locus 5 (SGR Sidney) und Bucket 10 (2018-01-14)\r\n'),
(500190120, 4913, 'fragment of brown wool open weave', '3.50', '3.00', NULL, 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 5, 17, 'thin', 's', 's', 1, 1, 'tight', 'tensioned', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a small and folded fragment of open weave in brown wool, featureless, packed as it was. ', '2025-02-03', NULL, '2019-01-19', NULL),
(500190122, 4918, 'badly decayed fragments of brown wool weave', '4.50', '3.00', NULL, 2, 'furnishing/household', NULL, NULL, NULL, 'weft-faced tabby', 6, 15, 'medium-thick', 's', 's', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '2 fragments of a badly decayed and soiled brown wool weave; the larger fragment contains the remain of a running stitch in s2z goat hair thread, unknown purpose; lightly de-soiled with a brush and a mini usb vacuum cleaner, packed as such. ', '2025-02-05', NULL, '2019-01-09', NULL),
(600180114, 3028, 'fragment of light-brown wool tabby', '4.70', '1.50', '0.20', 1, 'garment', NULL, NULL, NULL, 'warp-faced tabby', 13, 8, 'thin-medium', 's', 's', 1, 1, 'tensioned', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'browb', NULL, 'brown', 'small scrap of light-brown wool weave, slightly weft faced, with extremely tensioned presumably warps; the warp/weft identification was solely done on the account of the tension differentiation in the 2 systems, as warps tend to be spun more tightly; the only conservation treatment applied was de-dusting with a brush; accompanied by remains of cordage?', '2025-02-02', 'SGR Sidney', '2018-01-14', NULL),
(600190120, 4913, 'fragment of coarse ecru cotton basket weave', '7.00', '3.50', NULL, 1, 'household/industrial', NULL, NULL, NULL, 'basket (2WA/2WE)', 6, 6, 'medium-thick', 'z', 'z', 2, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a rather coarse and thick basket weave in cotton, soiled and folded. Packed as it was', '2025-02-03', NULL, '2019-01-19', NULL),
(600190122, 4917, 'fragment of brown wool weave, repurposed', '10.00', '8.00', '1.00', 1, 'garment', 'NK', 'strip', NULL, 'balanced tabby', 10, 13, 'thin', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a brown wool weave, relatively coarse, initially part of a garment? There are at least 2 interventions on this piece at different points in time; the first one may not have changed the initial function, and it is a rolled hem, made with s-spun yellow wool thread in running stitch; the second intervention, likely for repurposing, was to fold the textile  and sew it along the edge to form a thick strip shape with rounded corners. It is impossible to say what war the purpose, probably linked to household activities; the second stitch is both running and overcast, and is realized in s3z wool thread. The textile was wetted to unfold it and see the structural components, and dried flat; ', '2025-02-07', NULL, '2019-01-09', NULL),
(700180114, 3043, 'fragment of blue-ecru rhomboid tapestry', '3.50', '3.50', '0.10', 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 12, NULL, 'thin', 's', 's', 1, 1, 'very tight', NULL, NULL, NULL, NULL, NULL, 'wool', 'flax', 'flax', 'ecru', 'ecru', 'tapestry', 'blue', 'a rhombus section from a tapestry in blue and ecru weft. The ground weave is purely inferred based on the warp thread count; I am inferring that the flax weft is the ground weave; also, extremely difficult to tell if the ecru portion is indeed flax wefts or cotton. Interms of conservations, I de-dusted it with a brush, used a vacuum cleaner, and straightened a corner by applying water. ', '2025-02-02', NULL, '2018-01-10', NULL),
(700190120, 4913, '2 fragments of ecru sheep fleece', '6.00', '5.00', '0.50', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, NULL, 'ecru', NULL, NULL, 'ecru', '2 fragments of unprocessed sheep fleece, ecru', '2025-02-04', NULL, '2019-01-19', NULL),
(700190122, 4918, 'small fragment of fine wool weave', '3.80', '2.20', '0.10', 1, '', NULL, NULL, NULL, 'weft-faced tabby', 20, 54, 'very thin', 'z', 'i', 1, 1, 'tight', 'no spin (I)', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'ecru', 'ecru', NULL, 'ecru', 'a small fragment of a very fine wool weave, possible to be modern', '2025-02-05', NULL, '2019-01-09', NULL),
(800180114, 3043, 'a pile of wool threads, multicolor', '5.00', '6.00', '1.00', 1, 'NK', NULL, NULL, NULL, NULL, NULL, NULL, 'thick', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, NULL, 'multiplw', NULL, NULL, 'multiple', 'a pilo of wool threads, brown, light brown, blue, and dark blue; the 2 types of blue threads are s2z, the brown is s spun', '2025-02-02', NULL, '2018-01-10', NULL),
(800190120, 4913, 'a pile of unraveled yellow wool yarns', '3.50', '1.50', '1.00', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 's', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', '', 'wool', 'yellow', NULL, NULL, 'yellow', 'a pile of what looks like unraveled wool yarns. Yellow dyed; packed as it was. ', '2025-02-04', NULL, '2019-01-19', NULL),
(800190122, 4918, '2 fragments of yellow wool weave', '5.00', '2.00', '0.40', 2, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 11, 16, 'thin', 's', 's', 1, 1, 'tensioned', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '2 fragments of wool textile, rather thin but not of great quality, there is a lot of tension in the warp. The spin of yarns in incnsistent, and so is the diameter; packed as it was.', '2025-02-05', NULL, NULL, 'bucket unclear'),
(900180114, 3043, 'household cloth, flax, much decayed', '4.00', '2.30', '0.20', 1, 'household/industrial', NULL, NULL, NULL, 'weft-faced tabby', 8, 12, 'medium', NULL, NULL, 1, 1, 'medium', 'loose', '', NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a much decayed and crumpled piece of coarse flax textile, no diagnostic features, probably used in a household/industrial environment. De-dusted with a brush; flax confirmed by Arnaud Maurer on 3.2.2025, including the incomplete elimination of the lignous fibres, making a coarse fabric', '2025-02-02', NULL, '2018-01-10', NULL),
(900190120, 4913, 'a much decayed frag of brown wool', '5.00', '4.00', '0.50', 3, 'household/garment', NULL, NULL, NULL, 'balanced tabby', 8, 10, 'medium-thick', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '2 small fragments of a very decayed wool weave, brown; the fabric is rather thick, and the yarns are thick as well, it would have been a sturdy, warm material; packed as it was', '2025-02-04', NULL, NULL, 'bucket unclear'),
(900190122, 4918, 'small fragment of fine wool weave', '3.00', '1.30', NULL, 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 11, 20, 'very thin', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', '', 'yellow', 'a small fragment of yellow wool weave, rather thin, packed as it was', '2025-02-05', NULL, NULL, 'bucket unclear'),
(1000180114, 3043, 'fragment of flax basket weave with simple selvedge', '8.70', '5.50', '0.20', 2, 'pouch?', NULL, NULL, NULL, 'basket (2WA/2WE)', 12, 7, 'medium', 's', 's', 2, 2, 'medium-tight', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self-banding', 'ecru', 'an exciting flax piece, as much as I can recall the only textile at Berenike that I have seen so far to preserve it\'s complete width, selvedge to selvedge, of 8.7cm!! Coarse flax basket weave, at times more than 2 wefts are paired up to form bundeles of 3, 5, and up to 5 yarns per pass, simple selvedge; remains of sewing with a coarse hemp? thread on both selvedges appear to have connected this face with another piece of identical weave, perhaps the other side of the pouch? Conservation: laying it flat with the help of water on the textile creases. ', '2025-02-02', NULL, '2018-01-10', NULL),
(1000190120, 4913, 'pile of yellow wool threads', '7.00', '6.00', '1.00', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'thick', 's', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'yellow', NULL, NULL, 'yellow', 'a pile of wool threads, yellow, of various spin and yarn diameter. Some of the yarns were spun together with brown hairs.  Packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(1000190122, 4918, 'fragment of tightly woven brown garment', '5.00', '3.30', '1.00', 1, 'garment', 'padding fill', NULL, NULL, 'weft-faced tabby', 8, 43, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'brown', NULL, 'brown', 'a folded and soiled piece of garment, neatly and tightly woven, very consistent yern spin; the textile was crumpled and a decision was made to sew it onto somethign else as such, in  an s2z goat hair thread. The stitch appears to have been running stitch; gently de-soiled with a brush and packed as it was. ', '2025-02-06', NULL, '2019-01-09', NULL),
(1100180114, 3126, 'fragment of yellow half-basket wool weave', '2.50', '2.00', '0.30', 2, 'garment/furnishing', NULL, NULL, NULL, 'half-basket (1WA/2WE)', 6, 12, 'medium-thick', 'z', 'z', 1, 2, 'medium-tight', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a medium thick, durable half basket weave in wool, featureless; packed as it was', '2025-02-02', 'SGR Sidney', '2018-01-11', NULL),
(1100190120, 4913, 'lump of brown picked wool', '5.00', '3.00', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'brown', NULL, NULL, 'brown', 'a lump of brown wool, probably at an intermediary step in the spinning process; it looks like the wool had been picked but not combed. Packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(1100190122, 4920, 'fragment of coarse cotton weave', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'weft-faced tabby', 5, 12, 'medium-thick', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a small fragment of ecru cotton weave, a classic of Berenike, the thread may have expanded and become more \'fluffy\' due to the damp and salty medium in which it stayed in the trench; packed as it was', '2025-02-05', NULL, '2019-01-14', NULL),
(1200180114, 3126, 'fine yellow wool fragment', '2.50', '2.00', '0.30', 2, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 12, 35, 'thin', 's', 's', 1, 1, 'tight', 'loose', '', NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a small fragment of fine wool weave, featureless, slightly brushed for dust', '2025-02-02', 'SGR Sidney', '2018-01-11', NULL),
(1200190120, 4913, 'fragment of coarse wool weave with basket section', '3.50', '3.50', '0.10', 1, 'garment/household', NULL, NULL, NULL, 'balanced tabby', 7, 10, 'medium', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'self-banding', 'brown', 'interesting piece of thicker wool weave; there are 2 types of yarns used; in the warp a lighter brown one, and in the weft a darker and a lighter brown; a group of 5 shots of wefts is paired to form a half basket weave, then it is followed by 2 tabby weft shots in brown wool, and another 2 shots of tabby weave in lighter brown wool; the patter of half basket seems to repeat after this for at least 2 shots, but it is impossible to say whether half basket was the actual weave of the textile, or constituted just a self-banding section, due to the fragmentary nature of the piece; conservation wise, nothing else was done than unfolting for analysis', '2025-02-04', NULL, '2019-01-19', NULL),
(1200190122, 4919, 'scrap of ecru cotton weave', '3.50', '1.50', '0.30', 1, NULL, NULL, NULL, NULL, 'weft-faced tabby', 6, 12, 'medium', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a scrap of ecru cotton weave, featureless; packed as it was', '2025-02-05', NULL, '2019-01-22', NULL),
(1300180114, 3126, 'coarse brown wool weave', '3.50', '2.00', '0.30', 1, 'garment', NULL, NULL, NULL, 'balanced tabby', 11, 14, 'medium', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a rather coarse wool weave of a lower quality, inconsistency in weave and in thread spin. Packed as it was', '2025-02-02', 'SGR Sidney', '2018-01-11', NULL),
(1300190120, 4913, 'multi-color wool weave with selvedge and stitching', '4.00', '3.50', '1.20', 1, 'furnishing/household', NULL, NULL, NULL, 'weft-faced tabby', 9, 13, 'medium-thick', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', 'stripe', 'blue', 'a thicker wool weave that may have been either a thick overcoat or a furnishing item; it have a mainly indigo ground weave with at least 2 yellow stripes in the weft (one complete with 6 wefts, c. 0.3 cm width, the other one fragmentary, with only 6 wefts remaining) and an additional much thicker green stripe of c. 3 cm in width (c.55 wefts). Reinforced selvedge with extra oaired wrapping weft over 3 pairs of warps present; remains of stitching in coarse goat hair yarn s2z2s along the selvedges; the cloth was neatly folded in 3 and sewn along the selvedge, and from a few ewmains of other threads it appread it had been sown together with a different fabric. Packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(1300190122, 4919, 'fragment of ecru flax weave with self banding', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'weft-faced tabby', 6, 11, 'medium-thick', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self-banding', 'ecru', 'a small fragment of coarse flax weave, with 2 self-bands next to one another, each consisting of 3 presumably warps. Packed as it was;', '2025-02-05', NULL, '2019-01-22', NULL),
(1400180114, 3126, 'fine flax weave', NULL, NULL, NULL, 1, 'garment', 'tying', NULL, NULL, 'weft-faced tabby', 11, 28, 'thin', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a rather fine flax weave, one of the few recorded so far, possibly a germent, later tyed into a knot, used for fastening somethig or as a sash. No conservation, packed as it was. ', '2025-02-02', 'SGR Sidney', '2018-01-11', NULL),
(1400190120, 4913, 'fragment of brown wool weave', '5.50', '2.50', '0.50', 1, 'garment/household', NULL, NULL, NULL, 'balanced tabby', 11, 12, 'thin-medium', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a medium-thin brown wool weave, mostly decayed; the rather open weave structure is a result of unraveling, rather than design, as smaller sections of the weave are tighter and suggest that the facric was woven more tightly', '2025-02-04', NULL, '2019-01-19', NULL),
(1400190122, 4919, 'small fragment of ecru cotton weave', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'weft-faced tabby', 6, 11, 'medium-thick', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'damaged and soiled fragment of tabby weave in cotton, the fibres are meshed and mingled in the yarn, perhaps as a result of decay? rather \'fluffy\' appearance, possibly yet again due to decay and swallowing of the individual fibres; packed as it was. ', '2025-02-05', NULL, '2019-01-22', NULL),
(1500180114, 3126, 'scrap of brown wool weave', '1.00', '1.00', '0.30', 1, 'household/garment', NULL, NULL, NULL, NULL, NULL, NULL, 'medium', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', '', 'brown', 'a very small fragment of coarse wool weave, the fibres in the yarn look rather coarse, the look of a balanced tabby although one can only inferr; packed as it was', '2025-02-02', 'SGR Sidney', '2018-01-11', NULL),
(1500190120, 4913, 'fragment of brown tunic with red stripe', '9.50', '5.00', NULL, 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 6, 16, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', 'a fragment of light brown wool weave with a red stripe in the weft (?); the red stripe is 2.9cm and contains aprox. 49 wefts; the weave is inferred as weft faced tabby from examples with diagnostic features; it was soiled and folded, the conservation treatment consisted in de-soiling with a brush, and watering with de-ionized water on the folds; the watering had bad results, the fibres being stiffened, probably because of incomplete cleaning and re crystallized salt? ', '2025-02-04', NULL, '2019-01-19', NULL),
(1500190122, 4919, 'fragment of thin yellow wool weave', '6.40', '5.50', NULL, 1, 'garment', NULL, NULL, NULL, 'balanced tabby', 10, 14, 'thin-medium', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fragment of medium thin wool weave, with tightly spun yarns; interestingly, one weft shot was paired, without the continuation of the half basket pattern; possibly from a garment; packed as it was', '2025-02-05', NULL, '2019-01-22', NULL),
(1600180114, 3029, 'fragment of coarse cotton weave with cordage', '7.00', '4.00', '1.00', 1, 'household/industrial', NULL, NULL, NULL, 'balanced tabby', 8, 12, 'medium', 'z', 'z', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', '', 'brown', 'a coarse fragment of ecru cotton, accompanied by a coarse thread of hemp? Lightly brushed to remove soil and packed as it was', '2025-02-02', 'SGR Sidney', '2018-01-09', NULL),
(1600190120, 4913, 'fragment of cotton tie with stitch', NULL, NULL, NULL, 1, 'household', 'strip', NULL, NULL, 'weft-faced tabby', 8, 28, 'medium', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a medium thin cotton tabby, which was later on neatly folded in 3 and sewn alon one side to form a band of 1.5 cm in width with unknown use, perhaps a strap or a tying device; the picece is in an advance state of decay, only lightly de-soiled with a brush and packed. ', '2025-02-04', NULL, '2019-01-19', NULL),
(1700180114, 3029, 'fragment of coarse brown goat hair weave', '6.80', '4.30', '0.70', 1, 'household/industrial', NULL, NULL, NULL, 'balanced tabby', 4, 5, 'very thick', 's2z', 's2z', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a coarse goat hair weave, featureless; packed as it was', '2025-02-02', 'SGR Sidney', '2018-01-09', NULL),
(1700190120, 4913, 'fragment of heavy duty flax cloth', '9.00', '3.40', '0.20', 1, 'household/industrial', NULL, NULL, NULL, 'basket (2WA/2WE)', 6, 9, 'thick', 's', 's', 2, 2, 'loose', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', '', 'ecru', 'a heavy duty, coarse flax basket weave, probably not used for clothing; featureless; packed as it was. ', '2025-02-04', NULL, NULL, 'bucket unclear'),
(1800180114, 3029, 'fragment of coarse brown wool with yellow stripe', '5.80', '5.70', '0.50', 1, 'garmet/household', NULL, NULL, NULL, 'weft-faced tabby', 8, 12, 'thick', 's', 's', 1, 1, 'tensioned', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', 'a coarses wool weave with a thick yellow stripe in the weft presumably, preserved width to width (c. 2 cm, 26 wefts); corse wool, fit for an overgarment or furnishing; the piece is folded and crumpled and is accompanied by straw? or hemp remains inside, and a blue wool thread, s3z, wrapped around it probably as an accident of deposition and not intentionally; Lightly de-soiled with a brush and a mini vacuum cleaner, and left crumpled as it was together with the straw and wool thread in the original positions. ', '2025-02-03', 'SGR Sidney', '2018-01-09', NULL);
INSERT INTO `textile` (`Textile_ID`, `bucket_id`, `Textile_name`, `Length(cm)`, `Width(cm)`, `Hight(cm)`, `Number_of_fragments`, `Function`, `Functionality1`, `Functionality2`, `Textile_Item_ID1`, `Ground_weave`, `Warp_count`, `Weft_count`, `Perceived_thickness`, `Warp_spin/ply`, `Weft_spin/ply`, `Number_warps`, `Number_wefts`, `Warp_spin_tightness`, `Weft_spin_tightness`, `Warp_spin_angle`, `Weft_spin_angle`, `Warp_diameter(mm)`, `Weft_diameter(mm)`, `Warp_fibre`, `Weft_fibre`, `General_fibre`, `Warp_colour`, `Weft_colour`, `Decoration`, `General_colour`, `Textile_description`, `Date_analyzed`, `Locus_addition`, `Date_excavation`, `migration_note`) VALUES
(1800190120, 4913, 'fragment of yellow wool weave', '7.50', '2.00', '0.30', 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 7, 24, 'thin-medium', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a featureless fragment of weft-faced wool weave; packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(1900180114, 3029, 'fragment of extremely fine cotton weave with fringes', '8.30', '2.00', '0.30', 1, 'garment', NULL, NULL, NULL, 'warp-faced tabby', 14, 32, 'very thin', 's', 's', 1, 1, 'tensioned', 'very tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'self-banding', 'ecru', 'one of the finest cotton pieces I have ever seen at Berenike; it is either the finest Roman craftsmanship or a 19-th century inclusion, as this trench also gave fragments of a modern newspaper; we also have other 19th century remains from all over the extent of the isis temple, as the area was shortly excavate dback then, so it is not impossible; the textile preserves it full width, from beginning to end of cloth; the beginning of cloth is fringed, and reinforced with the addition of loops in the weft, see drawing; the end of cloth is reinforced with the help of an additional bundle of about 5 yarns that passes in an overcast stitch manner over the last weft pick and results in the warps accumulating as pile on face B of the cloth because of the angle at which the reinforcement is done; the textile is drawn and microscope photographed with FACE A = begginigng of cloth , innermost reinforcing thread forms a loop and the face does not have warps on it on the end of cloth; FACE B is the one with the end of cloth pile; due to the tension in the warps, the warps have plyed naturally together in the beggining of cloth, and looped in the end of the cloth; also, self banding presend mid-way through, 4 weft shots have paired yarns. The textile has been de-soiled with a brush and watered along the creases so it can be unfolded. ', '2025-02-03', 'SGR Sidney', '2018-01-09', NULL),
(1900190120, 4913, 'fragment of coarse brown wool weave with yellow stripe', '11.50', '2.50', '0.40', 1, 'household', NULL, NULL, NULL, 'balanced tabby', 6, 9, 'medium-thick', 's', 's', 1, 1, 'loose-medium', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', 'a coarse and thick brown wool weave, with 3 wefts? in yellow wool that form a very thin stripe. The quality is quite low, the yarns have been inconsistently spun, and yarns of various thickness are used. Packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(2000180114, 3029, 'fragment of yellow wool weave with red stripe', '4.00', '2.30', NULL, 5, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 11, 28, 'thin-medium', 's2z', 's', 1, 1, 'medium', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'yellow', 'stripe', 'yellow', 'a fine wool weave, probably from a garment; presents as decoration a red strip probably in the weft of. 3mm and made of 9 warps (preserved in full width on 2 pieces); interestingly, about 1/3 of the brown warp threads get replaced at an irregular interval by an s-spun yellow thread that was spun together with a very few fibres of blue wool; sometimes 2 such warps are placed in succession;  this would have probably made only a hint of a  difference in the apprearance of the design because of the tight weave, but is an interesting choice. Textile cleaned with brush adn mini-vacuum clieaner.  ', '2025-02-03', 'Sidney SGR', '2018-01-09', NULL),
(2000190120, 4913, 'fragment of cotton weave', '8.00', '2.50', '0.30', 1, 'garment/household', NULL, NULL, NULL, 'weft-faced tabby', 8, 14, 'thin', 's', 's', 1, 1, 'tensioned', 'tensioned', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a thin cotton fragment, may have functioned as cloth, I don\'t see it impossible; packed as it was. ', '2025-02-04', NULL, '2019-01-19', NULL),
(2100180114, 3029, 'fragment of brown wool weave', '2.50', '2.00', NULL, 1, 'garment/household', 'strap/band/tie', NULL, NULL, 'weft-faced tabby', 13, 18, 'thin-medium', 's', 's', 1, 1, 'medium', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a thin brown wool; remains of s2z wool stitch in brown yarn; packed as it was. ', '2025-02-03', NULL, NULL, 'bucket unclear'),
(2100190120, 4913, 'fragment of ecru cotton, modern?', '7.00', '1.50', NULL, 1, 'garment/household', NULL, NULL, NULL, 'balanced tabby', 20, 35, 'very thin', 'z', 'z', 1, 1, 'medium', 'loose-medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a very thin cotton weave, potentially modern. ', '2025-02-04', NULL, '2019-01-19', NULL),
(2200190120, 4913, 'fragment of light brown wool tabby', '8.50', '1.50', '1.00', 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 10, 21, 'very thin', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a featureless and crimpled piece of wool weave, riather fine and thin; packed as it was. ', '2025-02-04', NULL, '2019-01-19', NULL),
(2300190120, 4913, 'light brown wool tassel', '9.50', '2.50', '0.90', 1, 'garment/furnishing', NULL, NULL, NULL, NULL, NULL, NULL, 'very thick', 's', NULL, NULL, NULL, 'medium', NULL, NULL, NULL, NULL, NULL, 'wool', NULL, NULL, 'brown', NULL, NULL, 'brown', 'light-brown tassel, may have embellished a furnishing item', '2025-02-04', NULL, '2019-01-19', NULL),
(2400190120, 4913, 'fragment of wool half basket weave', NULL, NULL, NULL, 1, 'garment', NULL, NULL, NULL, 'half-basket (2WA/1WE)', 6, 28, 'medium', 's', 's', 2, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine yellow wool weave with an unusual paired warp; lightly de-soiled with a brush and packed.', '2025-02-04', NULL, '2019-01-19', NULL),
(2500190120, 4913, 'fragment of goat hair weave', '7.00', '5.00', '1.00', 1, 'tent/mat', NULL, NULL, NULL, 'balanced tabby', 4, 4, 'very thick', 's2z', 's2z', 1, 1, 'loose-medium', 'loose-medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a heavy duty goat hair weave that would have been used as matting, tenting, carpet, etc; interestingly it is woven with a combination of yellow and brown fibers; packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(2600190120, 4913, 'fragment of brown wool weave with yellow stripe', '4.50', '3.00', NULL, 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 8, 15, 'medium', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', 'a rather coarse wool weave in light brown with a stripe in dark yellow; yerns are rather coarse and spun unevenly; packed as it was', '2025-02-04', NULL, '2019-01-19', NULL),
(2700190120, 4911, 'fragment of multicolor carpet with pile', '4.00', '4.00', '1.00', 2, 'carpet', NULL, NULL, NULL, 'half-basket (1WA/3WE)', 7, 4, 'very thick', 'z2s', 'z', 1, 3, 'loose-medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'yellow', 'pile', 'multiple', 'a thick, colorful tightly woven textile, most likely a carpet; an additional piece of the carpet comes from BE20-137.001.PB001, as apparently both in antiquity and in the 19th century the area was dug and disturbed, which may have caused the movement of material. The warp yarns are blue, partially discolored and it looks from the decay of the color that the yarn has been dyed after it was plyed; the weft is a basket weave with added piles in darker yellow , red and blue; due to the state of preservation it is not clear how the pile was knotted, or if it was a looped pile or not; it appears that the blue threads were wrapped around the warps twice before making the pile, and that the pile was on the side opposite to the red and yellow piles, which makes no sense as all colors should pile on the same face of cloth; Face A in dicturas and drawings is the one with the red and yellow pile, and Face B with the blue pile; the blue pile seems to have drawn a specific design, as shown in the drawing; packed as it was, too fragile to try to unfold it; there is soil and gunk everywhere, particularly on the pile.', '2025-02-05', NULL, '2020-01-18', 'Doppelzuordnung zu Trench 120 und 137. Zuordnung zu Trench 137 aufgrund der Textile_ID aufgehoben. Zusätzliche Zuordnung zu Locus 2 und Bucket 3 (2019-01-19)'),
(2800190120, 4913, 'fragment of garment with red band', '7.50', '7.00', NULL, 1, 'garment', NULL, NULL, NULL, 'balanced tabby', 13, 16, 'thin', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'browb', 'brown', 'stripe', 'brown', 'fragment of a piece of garment, shawl or tunic, with a red stripe in the weft; the piece was gently desoiled with a brush and a mini vacuum cleaner, then damped along the creasing to straighten it;', '2025-02-06', NULL, '2019-01-19', NULL),
(2900190120, 4913, 'multiple fragments of yellow wool weave with stitching', '8.50', '4.50', '1.00', 8, 'garment', 'padding fill', NULL, NULL, 'weft-faced tabby', 8, 16, 'thin', 's', 's', 1, 1, 'medium-tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'badly damaged fragments of yellow wool weave, in such a bad condition that they desintegrate upon touch; folded, soiled, and with remains of charred material and straw; impossible to maneuvre without damage; the weave seems to have been repurposed somehow via at least 2 types of stitches; the purpose of stitching is unclear; the first is a running stitch in s2z goat hair yarn which apears to have been used to secure a fold in the fabric, perhaps the new hem? The second is an overcast stitch in blue s2z wool, which may have been done to reinforce the edge/hem of the fabric at that point. Another fragment of the textile shows 2 more threads used to create a rolled hem?, a yellow wool s3z yarn, and another thick S-spun flax?  Lightly desoiled with a brush but largely left as it was due to the bad state of conservation ', '2025-02-05', NULL, '2019-01-19', NULL),
(3000190120, 4913, 'fine reserve dyed cotton with blue vegetal pattern, wrapped around somethign', '8.00', '4.00', NULL, 3, 'garment/furnishing', 'amulet?', NULL, NULL, 'balanced tabby', 16, 24, 'very thin', 'z', 'z', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'multiple', 'multiple', 'vegetal pattern', 'multiple', 'a unique piece of z-spun \'Indian cotton\', with vegetal motifs reserve dyed; the piece was carefully wrapped with a strip around a piece of coral, unknown purpose; I have tried not to unwrap the piece, but after consideration and not being able to recreate the pattern without unwrapping, I decided to unwrap; the piece was wetted on the folds to straighten it; pictures were taken at all points. After unwrapping, the dimensions are 8 x 4 cm', '2025-02-07', NULL, '2019-01-19', NULL),
(3100190120, 4915, '2 fragments of brown garment with red stripe', NULL, NULL, NULL, 2, 'garment', 'NK', NULL, NULL, 'weft-faced tabby', 7, 12, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', '2 fragments of what was initially a garment, either a tunic or a shawl; thin to medium fabric; the yarns have been spun with fibres in both darker and lighter shades of brown, giving the yarn a \'variegated\' appearance under magnification; the warps are spun more tightly then the wefts; notably the red threads in the band have almost no spin; the stripe did not preserve its width; Later the larger fragment seemes to have been folded and sewn in a curve manner with an s3z wool thread, unknown purpose; packed as it was.  ', '2025-02-06', NULL, '2019-01-12', NULL),
(3200190120, 4915, 'fragment of brown wool weave', '5.00', '4.50', '0.30', 1, 'garment', NULL, NULL, NULL, 'balanced tabby', 13, 13, 'thin', 's', 's', 1, 1, 'tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'fragment of brown wool weave, rather thin, the warps are spun more tightly than the wefts; assessment of warp and weft is inferred from pieces with diagnostic features; lightly de soiled witha  brush and a mini vacuum cleaner, and packed. ', '2025-02-06', NULL, '2019-01-12', NULL),
(3300190120, 4915, 'fragment of thin flax weave', '4.50', '1.50', NULL, 1, NULL, NULL, NULL, NULL, 'balanced tabby', 10, 13, 'very thin', 's', 's', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'a small fine fragment of flax weave, balanced tabby, featureless; gently de-soiled with a brush and packed. ', '2025-02-06', NULL, '2019-01-12', NULL),
(3400190120, 4914, 'fragment of blue yarn, s4z', '4.50', '1.00', '0.50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'thick', 's4z', NULL, 1, NULL, 'medium', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, NULL, NULL, 'blue', 'a fragment of a thick s4z blue wool yarn', '2025-02-06', NULL, '2019-01-10', NULL),
(3500190120, 4912, '3 fragment of thick yellow  wool weave', '7.00', '3.40', '0.10', 3, NULL, NULL, NULL, NULL, 'weft-faced tabby', 6, 10, 'thick', 'z2s', 'z', 1, 1, 'medium', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', '3 fragments of thick yellow wool weave; the first fragment and the smallest belongs to  trench 120 locus 2 pb 004; on 2025/02/08 I found an additional 2 much larger and matching fragments in trench 120, locus 1, pb 002; the weave is interesting, as it employs z spun and z2s plied threads, contrary to the traditional types of wools usually found at Berenike. Packed as it is.', '2025-02-06', NULL, '2019-01-08', 'Zusätzliche Zuordnung zu Locus 2 und Bucket 4 (2019-01-10)'),
(3600190120, 4914, 'fragment of thick brown wool yarn with knot', '10.00', '1.00', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'thick', 's2z', NULL, NULL, NULL, 'medium', NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'brown', NULL, NULL, 'brown', 'fragment of wool thread, rather thick and coarse, also fluffy, with a knot at one end', '2025-02-06', NULL, '2019-01-10', NULL),
(3700190120, 4914, 'fragment of coarse cotton weave', '6.00', '3.50', NULL, 1, 'household/industrial', NULL, NULL, NULL, 'weft-faced tabby', 6, 14, 'thick', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'self-banding', 'ecru', 'fragment of a badly decayed cotton weave, probably used in household context; remains of one self band realized by pairing two wefts; lightly de-soiled with a brush and a mini vacuum cleanner, packed after', '2025-02-06', NULL, '2019-01-10', NULL),
(3800190120, 4914, 'fragment of yellow wool weave, used for roping', '6.50', '4.00', NULL, 1, 'garment', 'rope', NULL, NULL, 'weft-faced tabby', 7, 13, 'thin-medium', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'an interesting piece of yellow wool weave, later on wrapped around a rope, and sewn to it; May be part of the trappings for an animal? packed as it was', '2025-02-06', NULL, '2019-01-10', NULL),
(3900190120, 4914, 'fragment of light brown wool weave with blue strip', '5.50', '2.50', '1.00', 1, 'garment', NULL, NULL, NULL, 'balanced tabby', 10, 12, 'thin', 's', 's', 1, 1, 'tight', 'tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'stripe', 'yellow', 'a light brown weave with blue stripe, likely a garment. packed as it was', '2025-02-06', NULL, '2019-01-10', NULL),
(4000190120, 4916, 'fragment of garment selvedge', '4.00', '0.80', '0.10', 1, 'garment', NULL, NULL, NULL, NULL, NULL, NULL, 'thin', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a tiny strip of reinforced relvedge from a yellow wool weave, very finely done, probably a garment; reinforced selvedge over 2 warp bundles, interestingly, grading up of selvedge. ', '2025-02-06', NULL, '2019-01-13', NULL),
(4100190120, 4916, 'fragment of yellow weave with selvedge', '6.00', '4.50', '1.00', 1, 'garment', NULL, NULL, NULL, NULL, NULL, NULL, 'thin-medium', 's', 's', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a much decayed and soiled fragment of yellow wool weave with renforced selvedge; gently decrusted and de-dusted, unfortunately the piece partially desintegrated when doing that. ', '2025-02-06', NULL, '2019-01-13', NULL),
(4200190120, 4916, 'fragment of brown wool weave', '4.00', '3.00', NULL, 1, NULL, NULL, NULL, NULL, 'weft-faced tabby', 7, 11, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a decayed and crumbled piece of brown wool weave, featureless;  packed as it was', '2025-02-06', NULL, '2019-01-13', NULL),
(4300190120, 4916, 'fragment of cotton weave with selvedge', NULL, NULL, NULL, 1, 'household/garment', NULL, NULL, NULL, 'warp-faced tabby', 27, 8, 'medium', 'z', 'z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a simple cotton weave with simple selvedge preserved; packed as it was', '2025-02-06', NULL, '2019-01-13', NULL),
(4400190120, 4916, 'red wool roving wrapped around a cord?', '1.70', '1.00', '0.70', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'red', NULL, NULL, 'red', 'a entremely interesting piece; it looks like wool rovings prepared for the spinning process, which were wrapped around someform of hair cord, the remains of which are still inside the mini \'spool\'; certainly more evidence needs to be uncovered to claim that this was used in the spinning process and that it is evidence of an intermediary step in wool processing here at Berenike; but the fibres are certainly pre-spinning;packed as it was, during maneuvering to see the inside cord the rovings changed shape and unraveled minimally', '2025-02-06', NULL, '2019-01-13', NULL),
(4500190120, 4916, 'small fragment of blue open weave in wool with yellow stripe', '2.50', '1.40', '0.40', 1, 'garment', NULL, NULL, NULL, NULL, NULL, NULL, 'very thin', 's', 's', 1, 1, 'tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', 'stripe', 'blue', 'a small fragment of a thin, rather open weave in wool tabby, probably from a shawl; it has the full width of a strip conserved, including 10 threads; judging from the fact that most wool analyzed  this season are much more tightly spun in the warps, it seems this may have been a band instead, that is a stripe in the warp system; packed as it was', '2025-02-06', NULL, '2019-01-13', NULL),
(4600190120, 4916, 'small fragments of yellow wool weave', '3.00', '2.40', NULL, 3, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 6, 22, 'thin-medium', 's', 's', 1, 1, 'tensioned', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fne wool weave, likely from a garment; preserved in soiled scraps; the yarns are spun very consistently, great manufacture quality from this point of view; lightly desoiled with the brush and packed as such', '2025-02-06', NULL, '2019-01-13', NULL),
(4700190120, 4916, 'small yellow wool weave rolled and sewn', '5.50', '1.00', '0.70', NULL, NULL, NULL, NULL, NULL, 'weft-faced tabby', 10, 18, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a yellow wool weave, weft faced, presents the remains of a rolled hem with overcast stitch in s2z wool thread; packed as it was', '2025-02-06', NULL, '2019-01-13', NULL),
(4800190120, 4916, 'think blue with ecru wool yarn, knotted', '6.50', '1.00', '0.60', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'very thick', 's6z', NULL, NULL, NULL, 'tight', NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'blue', NULL, NULL, 'blue', 'a thick s6z wool yarn, in which 5 blue threads were plied with an ecru one; this thread was knotted togehter with another thick ecru woolen yarn, s spun. Packed as it was', '2025-02-06', NULL, '2019-01-13', NULL),
(4900190120, 4911, 'fine yellow tunic? with pile', '8.00', '1.00', '0.50', 1, 'garment/furnishing', NULL, NULL, NULL, 'half-basket (2WA/1WE)', 10, 55, 'thin', 's', 's', 2, 1, 'medium-tight', 'no spin (I)', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'pile', 'yellow', 'an extraordinary piece, the first of its kind that I see; this belongs either to a tunic or to a light piece of furnishing, it is of great craftsmanship; the threads in both systems are spun with great consistency, and are extremely thin; in the weft system, at regular intervals of 48-50 weft shots, 2 rows of pile are inserted, in yellow s2z wool yarns, see the drawing; the pile rows are consecutive and one  has paired pile; the piles were added on 1 in 2 warp threads; the length of the longest preserved pile is c. 1.4-1.5 cm; the warps are paired forming a hallf basked weave; packed as it was', '2025-02-07', NULL, '2019-01-07', NULL),
(5000190120, 4911, 'fine flax tunic fragment with purple band', '5.50', '2.00', NULL, 1, 'garment', NULL, NULL, NULL, 'half-basket', 7, 58, 'thin', 's', 's', 2, 58, 'medium', 'tight', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'tapestry', 'ecru', 'a very fine tunic in flax with tapestry decoration in purple wool and ecru flax; On the right edge of the surviving piece, purple wool wefts return in the weave and are grouped together, suggesting that dovetailing was used at the edge between the purple and ecru designs; none of the ecru portions of the tapestry, which probably created  profiles and contours of animals, human figures, or geometric motifs, survives, except 2 odd weft threads which both were wrapped around the warp once more before returning into the weave; there is a portion of the weft in flax, but I am assuminf it belongs to the ground weave; also, the warps exhibit an interesting phenomenon of alternating paired warp threads with bundles of 4 warp threads; sometimes these are bundles of 5 threads instead of the usual 4; packed as it was; ', '2025-02-07', NULL, '2019-01-07', NULL),
(5100190120, 4911, 'fragment of goat hair weave', '15.00', '7.50', '0.30', 1, 'carpet/tent', NULL, NULL, NULL, 'weft-faced tabby', 3, 6, 'very thick', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a very interesting goat hair weave, most likely from a tent or a carpet; at about 2 cm from one of the edges of the preserved piece, the weave pattern changes: initially the textile is a classic weft-faced tabby with 1 thread in each system, but then 2 warp threads are paired up to form a thicker warp; not all warps are paired, the sequence being 2  paired warps - 2 simple warps;  this  more tightly woven edge area resembles with the edge areas of may modern carpets; there are remains of a running stitch in a budle of 4 goat hair yarns; also, along the more tightly woven section at the edge there are faint changes in color which may suggest that the piece was sewn with 2 parallel rows of stitching along that line; gently brushed and packed as it was.', '2025-02-07', NULL, '2019-01-07', NULL),
(5200190120, 4911, 'fragment of coarse goat hair weave with selvedge', '5.00', '3.50', '0.20', 1, 'carpet/tent', NULL, NULL, NULL, 'balanced tabby', 2, 2, 'very thick', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a very thick but relatively open weave in goat hair, with preserved corded selvedge; the cord is an s2z3s; packed as it was.', '2025-02-07', NULL, '2019-01-07', NULL),
(5300190120, 4911, 'fragment of medium coarge goat hair weave', '6.00', '3.50', '1.00', 1, 'furnishing/household', NULL, NULL, NULL, 'balanced tabby', 5, 5, 'thick', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a medium thick goat hair weave, considerably thinner than others, with rather well plied threads; featureless; gently de-soiled with a brush and packed. ', '2025-02-07', NULL, '2019-01-07', NULL),
(5400190120, 4911, 'fragment of goat hair rope', '6.00', '2.00', '1.50', 1, 'industrial/household', NULL, NULL, NULL, NULL, NULL, NULL, 'very thick', NULL, NULL, NULL, NULL, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', NULL, 'goat hair', 'brown', 'brown', NULL, 'multiple', 'a very thick, heavy duty goat hair rope, unknown use; I do not know how to describe the construction technique, it\'s a combination of weaving with something else.', '2025-02-07', NULL, '2019-01-07', NULL),
(5500190120, 4911, 'plain cotton weave', NULL, NULL, NULL, 1, 'industrial/household', NULL, NULL, NULL, 'half-basket (1WA/2WE)', 22, 6, 'medium', 'z', 'z', 1, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', 'floating warps', 'ecru', 'a plain cotton weave, medium thickness; remains of parallel floating warps (entering the weave after 3 wefts)  along the preserved simple selvedge; ', '2025-02-07', NULL, '2019-01-07', NULL),
(5600190120, 4911, 'fragment of coarse flax weave with self banding', '7.00', '3.30', NULL, 1, 'household', NULL, NULL, NULL, 'balanced tabby', 7, 10, 'medium-thick', 's', 's', 1, 1, 'loose', 'loose', NULL, NULL, NULL, NULL, 'flax', 'flax', 'flax', 'ecru', 'ecru', 'self banding', NULL, 'a coarse flax weave with 3 self-bands done by paitring the threads; gently de-soiled with a brush and a mini vacuum cleaner and packed', '2025-02-07', NULL, '2019-01-07', NULL),
(5700190120, 4911, 'fragment of unknown purpose wool cord with weave', '2.80', '1.20', '0.70', 2, 'household', NULL, NULL, NULL, NULL, NULL, NULL, 'very thick', NULL, 's2z', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', '2 fragments, possibly from the same item; this is either a corded selvedge of a very thick wool textile, or a net like object for household purposesl I cannot make any sense of it; gently de-soiled and packed.', '2025-02-07', NULL, '2019-01-07', NULL),
(5800190120, 4911, 'pile of unraveled wool threads', '4.00', '3.00', '0.40', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'brown', NULL, NULL, 'brown', 'a pile of brown wool unraveled threads', '2025-02-07', NULL, '2019-01-07', NULL),
(5900190120, 4911, '2 fragments of fine yellow wool weave', '5.00', '2.80', NULL, 2, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 12, 29, 'thin', 's', 's', 1, 1, 'medium-tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', NULL, 'yellow', 'a fine yellow wool weave, featurelles; packed as it was', '2025-02-07', NULL, '2019-01-07', NULL),
(6000190120, 4911, 'a small fragment of open weave wool', '5.00', '2.50', NULL, 1, NULL, NULL, NULL, NULL, 'balanced tabby', 9, 8, 'thin', 's', 's', 1, 1, 'tensioned', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'small scrap of featureless brown wool weave, with extremely spun threads in one system; packed as it was', '2025-02-07', NULL, '2019-01-07', NULL),
(6100190120, 4911, 'a small fragment of half basket weave cotton', '2.00', '1.00', NULL, 1, NULL, NULL, NULL, NULL, 'half-basket', 10, 15, 'very thin', 's', 's', 1, 2, 'tight', 'tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a small scrap of half basket weave ecru cotton, suspiciously white and thin, may be faily well modern; packed as it was. ', '2025-02-07', NULL, '2019-01-07', NULL),
(6200190120, 4911, 'brown wool cord', '6.00', '0.70', '0.10', 1, 'tying', NULL, NULL, NULL, 'basket (3WA/3WE)', NULL, NULL, 'thick', 's', 's', 3, 3, 'medium', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a small fragment of these caracteristic cords that are made identically to reinforced selvedges; across 3 bundles of wars each of 3 threads, 3 wefts paired are crossed; there are remains of stitches with yellow wool thread on one side; packed as it was. ', '2025-02-07', NULL, '2019-01-07', NULL),
(6300190120, 4911, '3 fragments of yellow wool weave', NULL, NULL, NULL, 3, NULL, NULL, NULL, NULL, 'weft-faced tabby', 10, 20, 'thin-medium', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'orange', NULL, 'yellow', '3 small fragments of tightly woven wollen weave, the weft threads may have been dyed in orange once, leading to an allover orange appearance in the past; the color has now faded away; one weft is paired forming self banding, and another one is intentionally brown; packed as it was, only lightly brushed without much improvement;', '2025-02-08', NULL, '2019-01-07', NULL),
(6400190120, 4911, 'fragment of yellow wool weave with blue stripe, hemmed', '16.00', '5.00', '0.50', 1, 'garment', 'NK', NULL, NULL, 'tabby', 8, NULL, 'thin', 's', 's', 1, 1, 'tight', 'medium-tight', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'stripe', 'yellow', 'a long fragment of hemmed yellow wool weave, with a blue stripe; the weft count is imporrible to assess due to the preservation condition; at a later point when no longer suitable for the first purpose, the textile has been carefully hemmed (rolled hem) at what appears to be two separate moments in time; a first time with an organce s2z wool thread in overcast stitch over the edge, and a second time with a much thicker s2z2s yellow wool thread; the hemming has unclear purpose, but it is made probably for repurposing; packed as it was', '2025-02-08', NULL, '2019-01-07', NULL),
(6500190120, 4911, 'fragment of flax? weave with blue pile rows', '3.10', '2.90', NULL, 1, 'garment/furnishing', NULL, NULL, NULL, 'weft-faced tabby', 15, 22, 'thin', 's', 's', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'flax?', 'flax?', 'flax?', 'ecru', 'multiple', 'pile', 'multiple', 'a very small and fragile weft face weave, very thin, wwll spun yarns and well woven; the fibre escapes identification, it is either fine  flax, or very lean cotton; the item had a multi-color pile, blue and orange-brown, in a yarn that cannot be identified to to the extreme damage; the blue pile was realized in s2z yarn; the blue pile consists of yarn wrapped around either each warp, or one in 2 warps, and it was wrapped in weft-wise direction for a total width of c. 1.3 cm and c. 19 warps; 2 such piles were wrapped at a distance of 1 weft shot, and rows of 3 piles repeat at an interval of 5 wefts; on both right and left side, an orange - brown pile survives, which seems to have been done in the same manner; we do not seem to ahve the complete extent of the latter pile preserved; of what survived, it appreas that the orange pile was wrapped on 1 out of 2 warps; see drawing and micro photos for more info; packed as it was, very fragile', '2025-02-08', NULL, '2019-01-07', NULL),
(6600190120, 4911, 'wool know in yellow and blue', '1.00', '1.00', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'thick', 's4z', NULL, NULL, NULL, 'medium-tight', NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', '', NULL, NULL, 'multiple', 'a small fragment of corded border, or a knot made of s4z wool threads', '2025-02-08', NULL, '2019-01-07', NULL),
(6700190120, 4912, 'goat hait tabby', '6.00', '5.50', '0.10', 1, 'mat', NULL, NULL, NULL, 'balanced tabby', 4, 5, 'very thick', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'a fragment of coarse goat hair weave, probably from a mat, interestingly 2 colors of goat hair were used in the spinning process, brown and yellow; packed at it was. ', '2025-02-08', NULL, '2019-01-08', NULL),
(6800190120, 4911, 'tight brown wool weave', '6.00', '2.00', NULL, 1, 'garment', NULL, NULL, NULL, 'weft-faced tabby', 8, 18, 'thin', 's', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a small fragment of wool weave, folded in 2, measurements are of the folded version; neatly spun yarns and neat weaving, good craftsmanship; featureless; packed as it was', '2025-02-08', NULL, NULL, 'bucket unclear'),
(6900190120, 4911, 'tight and thin cotton weave, modern?', '3.50', '3.50', NULL, 1, NULL, NULL, NULL, NULL, 'balanced tabby', 22, 22, 'very thin', 'z', 'z', 1, 1, 'medium-tight', 'medium-tight', NULL, NULL, NULL, NULL, 'cotton', 'cotton', 'cotton', 'ecru', 'ecru', NULL, 'ecru', 'a small crumpled and folded fragment of cotton weave, in bad state of preservation; the yarn spin and the weave are very consistent, yarns in both systems seem identical and with the same spin angle, this may be an indication of a modern piece, 19th c? packed as it wass. ', '2025-02-08', NULL, '2019-01-08', NULL),
(7000190120, 4912, 'thick yellow wool weave with 2 blue tripes', '9.00', '8.00', '0.10', 1, 'garment/furnishing', NULL, NULL, NULL, 'weft-faced tabby', 6, 14, 'medium-thick', 's2z', 's', 1, 1, 'medium-tight', 'medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'yellow', 'stripe', 'yellow', 'a fragment of medium-thick yellow wool weave with 2 decorative stripes in the weft, in blue wool threads; the stripes comprise 20, and 18, respectively wefts, and measure c. 1 cm each; they are separated by 10 weft shots, measuring c. 0.8 cm; rather thick weave, the warps are inconsistently plyed; the wefts show a rather coarse fibre; suitable for a thick garment or a furnishing; packed as it was', '2025-02-08', NULL, '2019-01-08', NULL),
(7100190120, 4912, 'medium-thick yellow wool weave with brown stripes', '7.00', '8.00', NULL, 1, 'furnishing/garment', NULL, NULL, NULL, 'balanced tabby', 8, 11, 'medium-thick', 's', 's', 1, 1, 'tensioned', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', 'stripe', 'brown', 'a light-brown thicker weave in sheep\'s wool, fit for a furnishing or thicker garment, with remains of a brown stripe in the weft; the stripe consists of 9 shots of very thick, brown wool threads, in which a mix of yellow and dark brown fibres were included; the textile looks coarse, and the yarn spin and weave is inconsistent; warp pairing present once; the warps are very thin and tensioned on spinning, and the wefts are very heavy, coarse, and include coarse fibres; wetted on the creasing to straighten it and packed; ', '2025-02-08', NULL, '2019-01-08', NULL),
(7200190120, 4912, 'medium brown open wool weave', '6.50', '2.00', '0.40', 2, NULL, NULL, NULL, NULL, 'balanced tabby', 6, 11, 'thin-medium', 's', 's', 1, 1, 'tensioned', 'tensioned', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a rather opwn weave in brown wool, partially desintegrated and loosened up, therefore the weave count may be smaller than it actually was; the spin is very tight in both systems, and all threads include rather coarse fibres; packed as it was. ', '2025-02-08', NULL, '2019-01-08', NULL),
(7300190120, 4912, 'pile of brown wool rovings?', '7.00', '3.00', '0.50', 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', NULL, 'wool', 'brown', NULL, NULL, 'brown', 'a pile of wool fibres, I am unsure if they are dyed or not; it looks like they have been at least scoured, it not carded; packed as they were.', '2025-02-08', NULL, '2019-01-08', NULL),
(7400190120, 4912, 'fine wool weave in brown', '17.00', '13.00', NULL, 2, 'garment', NULL, NULL, NULL, 'half-basket (2WA/1WE)', 7, 40, 'thin-medium', 's', 's', 2, 1, 'medium-tight', 'loose-medium', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a finely woven brown wool weave, likely from a garment; yarns consistently spun, weave consistently executed, high quality; pairing of warps; featureless, except several regular holes in the bigger fragment potentially indicating remains of running stitch; the fragments came form a pottery bucket where most textiles were meshed with goat hair; lightly de-soiled with a brush and a mini vacuum cleaner, and damped on the folds to straighten it a bit. ', '2025-02-08', NULL, '2018-01-08', NULL),
(7500190120, 4912, 'tabby flax weave, part of larger item', '19.00', '6.50', '0.30', 2, NULL, NULL, NULL, 7, 'weft-faced tabby', 10, 15, 'thin', 's', 's', 1, 1, 'medium', 'tight', NULL, NULL, NULL, NULL, 'flax ', 'flax', 'flax', 'ecru', 'ecru', NULL, 'ecru', 'flax textile evenly woven but with rather coarse flax fibres,part of a larger textile item; at least 2 layers of thhis textile ID were sewn together with TX 76 in order to form an object that had a gathered side, of unknow purpose; a second stitch united the same two textile ids, as welll as random fragments of tx 75 together,  with another thicker wool srunning stitch in s3z wool thread, 1 thread brown, the other two yellow; impossible to establish the repurposing, perhaps some utilitarian purpose in the household; packed as it was. ', '2025-02-08', NULL, NULL, 'bucket unclear'),
(7600190120, 4912, 'tabby blue wool waeve, part of textile item', '6.00', '4.00', NULL, 2, 'garment', NULL, NULL, 7, 'tabby', NULL, NULL, 'very thin', 's', 's', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'blue', 'blue', NULL, 'blue', 'an open weave in blue wool, fit for a shawl; part of textile item 7; has been stitched to tx 75 along one end to form a gathered area, serving an unknown purpose (s2z hemp thread?). At a later stage in time, a secondary stitch fixed the weave along the same tx 75 via running stitch in s3z coarse wool thread, of which 2 yarns are brown and one yellow; unknown purpose again; packed as it was ', '2025-02-08', NULL, NULL, 'bucket unclear'),
(7800190120, 4912, 'goat flax weave, part of padding amalgam', '16.00', '13.00', '1.00', 2, 'tent/mat', 'padding amalgam', NULL, 8, 'weft-faced tabby', 4, 8, 'very thick', 's2z', 's2z', 1, 1, 'medium', 'medium', NULL, NULL, NULL, NULL, 'goat hair', 'goat hair', 'goat hair', 'brown', 'brown', NULL, 'brown', 'thick, heavy duty goat hair weave used as one side of a padding amalgam that had to be flat on one side; the amalgam is composed of at least 4 different textiles, inv. nos 78, 79, 80, and 81, but potentially more could be found if the piece is dismantled; a choice was made to keep the piece as it is to preserve it\'s functionality; the amalgam had the goat hair weave on one side, and a regularly thick pile of meshed textiles on the other, wiithin which tx 79 seems to be most of the cloth; 6 or more layers of tx 79 were folded on top of one another and, together with other individual textiles, newtly sewn with a 4 rows of running stitches, parralel to one another at a 2.5 - 3 cm distance; unfortunately the piece is cut in 2 parts, and the cut is neat and seems modern, maybe an artifact of the excavation practice? perhaps it was cut by a shovel? gently de-soiled with a brush and a vacuum cleaner and packed as it is. ', '2025-02-08', NULL, '2018-01-08', NULL),
(7900190120, 4912, 'light brown fine wool weave in padding amalgam', '16.00', '13.00', '1.00', 1, 'garment', 'padding amalgam', NULL, 8, 'weft-faced tabby', 8, 43, 'very thin', 's', 's', 1, 1, 'medium-tight', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'brown', 'brown', NULL, 'brown', 'a fine, thin and tightly woven wool weave, likely light brown or yellow in it\'s original state; consistently spun yarns; mixed and mashed into a padding amalgam (item no. 8); very degraded and crumbly; could not identify any diagnostic feature; ', '2025-02-08', NULL, '2018-01-08', NULL),
(8000190120, 4912, 'fine yellow wool weave with orange and green stripes, part of padding amalgam', '2.00', '2.00', NULL, 1, 'garment', 'padding amalgam', NULL, 8, 'weft-faced tabby', 8, 30, 'thin', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'multiple', 'stripe', 'multiple', 'a fine, thin-medium wool weave with what appears to be stripes of orange and green; the piece is very much decayed, making the technical fieatures identification very difficult and unreliable; it is impossible to say if the normal ground weave wefts were yellow or not; the only section of the wefts which survives is about 0.5 cm in width worth of orange wefts, and another similar section in green wefts; the green stripe was done with paired wefts , 1 shot green, one shot yellow, and repeating; ', '2025-02-08', NULL, '2018-01-08', NULL),
(8100190120, 4912, 'a minute fraction of a blue wool weave, likely a tapestry', '1.00', '1.00', NULL, 1, 'garment', 'padding amalgam', NULL, 8, 'tabby', NULL, NULL, 'thin', 's', 's', 1, 1, 'medium', 'loose', NULL, NULL, NULL, NULL, 'wool', 'wool', 'wool', 'yellow', 'blue', 'tapestry', 'blue', 'a minute fraction of a fragment possibly from the tapestry of a garment; impossible to say more, it\'s hideen under stitching', '2025-02-08', NULL, '2018-01-08', NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_hem`
--

CREATE TABLE `textile_hem` (
  `Textile_ID5` bigint(20) NOT NULL,
  `Hem_ID1` varchar(45) NOT NULL,
  `Stitch_name2` varchar(45) NOT NULL,
  `Thread_ID2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_hem`
--

INSERT INTO `textile_hem` (`Textile_ID5`, `Hem_ID1`, `Stitch_name2`, `Thread_ID2`) VALUES
(481059, 'RH', 'running stitch', 15),
(711059, 'FH', 'NK', 0),
(971059, 'RH', 'NK', 0),
(981059, 'FH', 'slanting stitch', 0),
(1771059, 'RH', 'slanting stitch', 2),
(1991059, 'RH', 'slanting stitch', 10),
(2091059, 'RH', 'overcast stitch', 3),
(2191059, 'FH', 'backstitch', 9),
(2271059, 'RH', 'slanting stitch', 8),
(2511059, 'RH', 'slanting stitch', 11),
(2581059, 'RH', 'overcast stitch', 3),
(2641059, 'RH', 'backstitch', 6),
(2711059, 'RH', 'slanting stitch', 8),
(2741059, 'SH', 'overcast stitch', 12),
(600190122, 'RH', 'running stitch', 34),
(2900190120, 'RH', 'overcast stitch', 25),
(2900190120, 'RH', 'overcast stitch', 26),
(4700190120, 'RH', 'overcast stitch', 33),
(6400190120, 'RH', 'overcast stitch', 38),
(6400190120, 'RH', 'overcast stitch', 39);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_item`
--

CREATE TABLE `textile_item` (
  `Textile_Item_ID` int(11) NOT NULL COMMENT 'An item is a composite textile entity, in which multiple individual textiles (which were often of other initial functions) were used, such as: padding amalgams, patches on textiles that use other weaves, textiles that comprise different weaves.\nOr, conversely, it is a textile that has multiple patches or sections in which various, originally individual textiles, were used.',
  `Textile_Item_Name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_item`
--

INSERT INTO `textile_item` (`Textile_Item_ID`, `Textile_Item_Name`) VALUES
(1, 'Padding amalgam'),
(2, 'padding amalgam'),
(3, 'fastened and bundled textile'),
(4, 'NK'),
(5, 'NK'),
(6, 'household, storage, or industrial'),
(7, 'storage item'),
(8, 'padding amalgam');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_seam`
--

CREATE TABLE `textile_seam` (
  `Stitch_name1` varchar(20) NOT NULL,
  `Thread_ID1` int(11) NOT NULL,
  `Textile_ID3` bigint(20) NOT NULL,
  `Textile_ID4` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_seam`
--

INSERT INTO `textile_seam` (`Stitch_name1`, `Thread_ID1`, `Textile_ID3`, `Textile_ID4`) VALUES
('overcast stitch', 6, 2631059, 2641059),
('running stitch', 3, 2061059, 2061059),
('running stitch', 3, 2731059, 2731059),
('running stitch', 6, 2211059, 2221059),
('running stitch', 6, 2211059, 2231059),
('running stitch', 6, 2221059, 2231059),
('running stitch', 7, 2211059, 2231059),
('running stitch', 7, 2221059, 2211059),
('running stitch', 7, 2221059, 2231059),
('running stitch', 13, 2731059, 2731059),
('running stitch', 14, 3291059, 3291059),
('running stitch', 40, 7500190120, 7500190120),
('running stitch', 40, 7500190120, 7600190120),
('running stitch', 41, 7500190120, 7500190120),
('running stitch', 41, 7500190120, 7600190120),
('slanting stitch', 1, 2701059, 2701059),
('slanting stitch', 18, 200180111, 200180111),
('slanting stitch', 20, 100180111, 200180111);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_selvedge`
--

CREATE TABLE `textile_selvedge` (
  `Textile_ID2` bigint(20) NOT NULL,
  `Selvedge_ID1` varchar(45) NOT NULL,
  `Stitch_name5` varchar(45) DEFAULT NULL,
  `Thread_ID5` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_selvedge`
--

INSERT INTO `textile_selvedge` (`Textile_ID2`, `Selvedge_ID1`, `Stitch_name5`, `Thread_ID5`) VALUES
(371059, 'RS3WA(2,2,2)EWE(2)', NULL, NULL),
(441059, 'SS', NULL, NULL),
(551059, 'RS2WA(S4Z, S4Z)EWE(2)', NULL, NULL),
(641059, 'RS1WA(1)CORD', NULL, NULL),
(661059, 'RS3WA(1, 1, 1)1PASS', NULL, NULL),
(671059, 'FS', NULL, NULL),
(721059, 'RS3WA(3,3,3)EWE(1)', NULL, NULL),
(821059, 'SS', NULL, NULL),
(901059, 'SS', NULL, NULL),
(911059, 'RS3WA(2,2,2)EWE(2)', NULL, NULL),
(1011059, 'RS3WA(3,3,3)EWE(2)', NULL, NULL),
(1051059, 'SS', NULL, NULL),
(1061059, 'RS3WA(3,3,3)EWE(2)', NULL, NULL),
(1271059, 'RS3WA(3,3,3)EWE(2)', NULL, NULL),
(1501059, 'RS5WA(3,3,3,3,3)1PASS', NULL, NULL),
(1801059, 'SS', NULL, NULL),
(1961059, 'PS', NULL, NULL),
(2061059, 'SS', NULL, NULL),
(2151059, 'RS3WA(2,2,2)EWE(2)', NULL, NULL),
(2181059, 'FS', 'Slanting stitch', 5),
(2201059, 'SS', NULL, NULL),
(2271059, 'SS', NULL, NULL),
(2651059, 'RS1WA(1)CORD', NULL, NULL),
(2781059, 'RS3WA(M,M,M)EWE(2)', NULL, NULL),
(2851059, 'RS3WA(2,2,2)EWE(2)', NULL, NULL),
(2881059, 'SS', NULL, NULL),
(2971059, 'RS2WA(M,M)EWE(2)', NULL, NULL),
(3021059, 'RS2WA(3,3)EWE(3)', NULL, NULL),
(3201059, 'RS3WA(3,3,3)EWE(2)', NULL, NULL),
(3281059, 'SS', NULL, NULL),
(100180118, 'RS3WA(3,4,3)EWE(3)', NULL, NULL),
(1000180114, 'SS', NULL, NULL),
(1300190120, 'RS3WA(2,2,2)EWE(2)', NULL, NULL),
(4000190120, 'RS2WA(3,4)1PASS', NULL, NULL),
(4100190120, 'RS3WA(3,3,3)EWE(2)', NULL, NULL),
(4300190120, 'SS', NULL, NULL),
(5200190120, 'RS1WA(1)CORD', NULL, NULL),
(5500190120, 'SS', NULL, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_sewing`
--

CREATE TABLE `textile_sewing` (
  `Textile_ID10` bigint(20) NOT NULL,
  `Stitch_name7` varchar(45) NOT NULL,
  `Thread_ID7` int(11) NOT NULL,
  `Purpose stitch` varchar(45) DEFAULT NULL,
  `Description` varchar(300) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_sewing`
--

INSERT INTO `textile_sewing` (`Textile_ID10`, `Stitch_name7`, `Thread_ID7`, `Purpose stitch`, `Description`) VALUES
(481059, 'NK', 15, 'NK', 'fragments of a secondary stitch in s2z ecru flax on the hem, unknown function'),
(871059, 'running stitch', 17, 'NK', 'a tiny fragment of stitching, ending in a knot, unknown purpose'),
(891059, 'overcast stitch', 3, 'reinforcement', 'stitching of the rolled cloth, probably for repurposing'),
(1021059, 'running stitch', 8, 'NK', 'unknown function of stitching'),
(1041059, 'NK', 0, 'NK', 'fragments of stitching, too decayed for assessment'),
(2201059, 'running stitch', 6, 'NK', 'possibly stitching the piece to a lerger padding amalgam, jugging from the shape of the textile and that of the stitching as well.'),
(2201059, 'running stitch', 9, 'NK', 'possibly stitching the piece to a lerger padding amalgam, jugging from the shape of the textile and that of the stitching as well.'),
(2211059, 'running stitch', 3, 'NK', 'a large, rare, running stitch of unknown purpose on the edge of the textile'),
(2271059, 'running stitch', 6, 'NK', 'possibly stitching the piece to a lerger padding amalgam, jugging from the shape of the textile and that of the stitching as well.'),
(2271059, 'running stitch', 9, 'NK', 'possibly stitching the piece to a lerger padding amalgam, jugging from the shape of the textile and that of the stitching as well.'),
(2431059, 'NK', 0, 'NK', 'traces of stitching, but missing yarn'),
(2621059, 'running stitch', 9, 'reinforcement', 'a corded border (s2z3s) was attached to the textile, from which an s2z thread goes out, sews the textile, and goes back into the cord'),
(2641059, 'running stitch', 9, 'padding amalgam', 'remains of running stitch, put impossible to demostrate whether they are made for the padding amalgam or not'),
(2661059, 'running stitch', 9, 'NK', 'unknown function'),
(2661059, 'running stitch', 12, 'NK', '2 parallel running stitches, unknown function'),
(200180111, 'NK', 19, 'NK', 'a very thick thread s10z appparently of cotton, probably to repair the already existing seam?'),
(300190122, 'backstitch', 29, 'structural', 'unknown purpose, perhaps part of construction of the goat hair item'),
(500190122, 'running stitch', 30, 'NK', 'remains of stitching, apparently running stitch, potentially some reinfrcement as wekk, unknown purpose'),
(1000180114, 'overcast stitch', 21, 'NK', 'a very coarse stitch surviving with a knot, that fixed one piece of the weave to the other, perhaps creating a pouch or another storage cloth? the thread is extremely coarse, maybe hemp?'),
(1300190120, 'overcast stitch', 22, 'NK', 'a very coarse stitching thread in s2z2s goat hair was used to fasten the cloth after it had been neatly folded in 3; it may have been attached to another textile judging from the remains'),
(1600190120, 'running stitch', 23, 'repurposing cloth into tie', 'a much decayed remain of a running stitch in what appears to be flax heavy duty, thick s2z yarn, used to transform the cotton cloth into some form of band or tie'),
(1800190120, 'NK', 24, 'NK', 'fragment of a stitch with which the textile was fastened somehow, impossible to say for what purpose'),
(2900190120, 'running stitch', 28, 'repurposing', 'same as ID 27, it is not clear the purpose, redrawing the hem area of the textile?'),
(2900190120, 'slanting stitch', 27, 'repurposing', 'unknown purpose, seems to have repurposed the textile into something new, and seems to have been also placed along the edges, perhaps part of the reinforcement of the hem?'),
(3100190120, 'running stitch', 31, 'repurposing', 'curved line of stitches uniting 2 pieces of the same textile, for unknown repurposing. '),
(3200190120, 'slanting stitch', 32, 'repurposing', 'a slanted stich in heavy flax yarn, apparently to fix the cloth piece onto a hemp? rope, probably fastening one end of the rope; '),
(5100190120, 'running stitch', 36, 'nk', 'a fragment of running stitch in heavy duty goat hair bundle of threads; unknow purpose. '),
(6200190120, 'NK', 37, 'NK', 'remains of stitching thread on one edge of the cord, unknown purpose'),
(7800190120, 'running stitch', 42, 'repurposing', 'stitch to sew the padding amalgam together'),
(7900190120, 'running stitch', 42, 'repurposing', 'stitch to sew the padding amalgam together'),
(8000190120, 'running stitch', 42, 'repurposing', 'stitch to sew the padding amalgam together'),
(8100190120, 'running stitch', 42, 'repurposing', 'stitch to sew the padding amalgam together');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_starting/finishing_border`
--

CREATE TABLE `textile_starting/finishing_border` (
  `Textile_ID1` bigint(20) NOT NULL,
  `Starting/Finishing_Border_ID` varchar(10) NOT NULL,
  `Stiching_name6` varchar(45) DEFAULT NULL,
  `Thread_ID6` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_starting/finishing_border`
--

INSERT INTO `textile_starting/finishing_border` (`Textile_ID1`, `Starting/Finishing_Border_ID`, `Stiching_name6`, `Thread_ID6`) VALUES
(411059, 'CB', NULL, NULL),
(891059, 'CB', NULL, NULL),
(2041059, 'CB', NULL, NULL),
(2281059, 'CB', NULL, NULL),
(2371059, 'CB', NULL, NULL),
(2491059, 'CB', NULL, NULL),
(3431059, 'CB', NULL, NULL),
(1900180114, 'FB', NULL, NULL),
(1900180114, 'TB', NULL, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `textile_structural_feature`
--

CREATE TABLE `textile_structural_feature` (
  `Textile_ID9` bigint(20) NOT NULL,
  `Structural_feature_name1` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `textile_structural_feature`
--

INSERT INTO `textile_structural_feature` (`Textile_ID9`, `Structural_feature_name1`) VALUES
(551059, 'pile'),
(671059, 'fringe'),
(1041059, 'self-banding'),
(2061059, 'fringe'),
(2061059, 'tassel'),
(2111059, 'pile'),
(2171059, 'pile'),
(2231059, 'pile'),
(2351059, 'self-banding'),
(2421059, 'self-banding'),
(2901059, 'pile'),
(3121059, 'looped pile'),
(3291059, 'self-banding'),
(3451059, 'self-banding'),
(3471059, 'pile'),
(1000180114, 'self-banding'),
(1200190120, 'self-banding'),
(1300190122, 'self-banding'),
(1900180114, 'fringe'),
(1900180114, 'self-banding'),
(2700190120, 'pile'),
(3700190120, 'self-banding'),
(4900190120, 'pile'),
(5600190120, 'self-banding'),
(6500190120, 'pile');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `weave`
--

CREATE TABLE `weave` (
  `Weave_name` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `weave`
--

INSERT INTO `weave` (`Weave_name`) VALUES
('balanced tabby'),
('basket (2WA/2WE)'),
('basket (3WA/2WE)'),
('basket (3WA/3WE)'),
('basket (4WA/2WE)'),
('compound'),
('diamond twill'),
('half-basket'),
('half-basket (1WA/2WE)'),
('half-basket (1WA/3WE)'),
('half-basket (1WA/4WE)'),
('half-basket (2WA/1WE)'),
('half-basket (4WA/1WE)'),
('satin'),
('tabby'),
('twill'),
('warp-faced compound'),
('warp-faced tabby'),
('weft-faced broken twill'),
('weft-faced compound'),
('weft-faced tabby');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `weave_thickness`
--

CREATE TABLE `weave_thickness` (
  `weave_thickness` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Daten für Tabelle `weave_thickness`
--

INSERT INTO `weave_thickness` (`weave_thickness`) VALUES
('medium'),
('medium-thick'),
('NA'),
('NK'),
('thick'),
('thin'),
('thin-medium'),
('very thick'),
('very thin');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `embridery_stitch_stitching_thread`
--
ALTER TABLE `embridery_stitch_stitching_thread`
  ADD PRIMARY KEY (`Embrodery_ID1`,`Stitch_name4`,`Thread_ID4`),
  ADD KEY `Stitch_name3_idx` (`Stitch_name4`),
  ADD KEY `Thread_ID4_idx` (`Thread_ID4`);

--
-- Indizes für die Tabelle `embroidery`
--
ALTER TABLE `embroidery`
  ADD PRIMARY KEY (`Embroidery_ID`),
  ADD KEY `Textile_ID7_idx` (`Textile_ID7`);

--
-- Indizes für die Tabelle `hem`
--
ALTER TABLE `hem`
  ADD PRIMARY KEY (`Hem_ID`);

--
-- Indizes für die Tabelle `reparation`
--
ALTER TABLE `reparation`
  ADD PRIMARY KEY (`Reparation_ID`),
  ADD KEY `Stitch_name3_idx` (`Stitch_name3`),
  ADD KEY `Thread_ID3_idx` (`Thread_ID3`),
  ADD KEY `Textile_ID6_idx` (`Textile_ID6`);

--
-- Indizes für die Tabelle `selvedge`
--
ALTER TABLE `selvedge`
  ADD PRIMARY KEY (`Selvedge_ID`);

--
-- Indizes für die Tabelle `spin_tightness`
--
ALTER TABLE `spin_tightness`
  ADD PRIMARY KEY (`Spin_tightness`);

--
-- Indizes für die Tabelle `starting/finishing_border`
--
ALTER TABLE `starting/finishing_border`
  ADD PRIMARY KEY (`Starting/Finishing_Border_ID`);

--
-- Indizes für die Tabelle `stitch`
--
ALTER TABLE `stitch`
  ADD PRIMARY KEY (`Stitch_name`);

--
-- Indizes für die Tabelle `stitching_thread`
--
ALTER TABLE `stitching_thread`
  ADD PRIMARY KEY (`Thread_ID`);

--
-- Indizes für die Tabelle `structural_feature`
--
ALTER TABLE `structural_feature`
  ADD PRIMARY KEY (`Structural_feature_name`);

--
-- Indizes für die Tabelle `tapestry`
--
ALTER TABLE `tapestry`
  ADD PRIMARY KEY (`Tapestry_ID`),
  ADD KEY `Weave_name1_idx` (`Weave_name1`),
  ADD KEY `Textile_ID8_idx` (`Textile_ID8`);

--
-- Indizes für die Tabelle `tapestry_feature`
--
ALTER TABLE `tapestry_feature`
  ADD PRIMARY KEY (`Tapestry_feature_name`);

--
-- Indizes für die Tabelle `tapestry_tapestry_feature`
--
ALTER TABLE `tapestry_tapestry_feature`
  ADD PRIMARY KEY (`Tapestry_ID1`),
  ADD KEY `Tapestry_feature_name1_idx` (`Tapestry_feature_name1`);

--
-- Indizes für die Tabelle `textile`
--
ALTER TABLE `textile`
  ADD PRIMARY KEY (`Textile_ID`),
  ADD KEY `Textile_item_ID1_idx` (`Textile_Item_ID1`),
  ADD KEY `Ground_weave_idx` (`Ground_weave`),
  ADD KEY `Warp_spin_tightness_idx` (`Warp_spin_tightness`),
  ADD KEY `Weft_spin_tightness_idx` (`Weft_spin_tightness`),
  ADD KEY `Perceived_thickness_idx` (`Perceived_thickness`);

--
-- Indizes für die Tabelle `textile_hem`
--
ALTER TABLE `textile_hem`
  ADD PRIMARY KEY (`Textile_ID5`,`Hem_ID1`,`Stitch_name2`,`Thread_ID2`),
  ADD KEY `Stitch_name2_idx` (`Stitch_name2`),
  ADD KEY `Hem_ID1_idx` (`Hem_ID1`),
  ADD KEY `Thread_ID2_idx` (`Thread_ID2`);

--
-- Indizes für die Tabelle `textile_item`
--
ALTER TABLE `textile_item`
  ADD PRIMARY KEY (`Textile_Item_ID`);

--
-- Indizes für die Tabelle `textile_seam`
--
ALTER TABLE `textile_seam`
  ADD PRIMARY KEY (`Stitch_name1`,`Thread_ID1`,`Textile_ID3`,`Textile_ID4`),
  ADD KEY `Thread_ID1_idx` (`Thread_ID1`),
  ADD KEY `Textile_ID4_idx` (`Textile_ID4`),
  ADD KEY `Textile_ID3_idx` (`Textile_ID3`,`Textile_ID4`);

--
-- Indizes für die Tabelle `textile_selvedge`
--
ALTER TABLE `textile_selvedge`
  ADD PRIMARY KEY (`Textile_ID2`,`Selvedge_ID1`),
  ADD KEY `Selvedge_ID1_idx` (`Selvedge_ID1`),
  ADD KEY `Stitch_name4_idx` (`Stitch_name5`),
  ADD KEY `Thread_ID4_idx` (`Thread_ID5`);

--
-- Indizes für die Tabelle `textile_sewing`
--
ALTER TABLE `textile_sewing`
  ADD PRIMARY KEY (`Textile_ID10`,`Stitch_name7`,`Thread_ID7`),
  ADD KEY `Stitch_name7_idx` (`Stitch_name7`),
  ADD KEY `Thread_ID7_idx` (`Thread_ID7`);

--
-- Indizes für die Tabelle `textile_starting/finishing_border`
--
ALTER TABLE `textile_starting/finishing_border`
  ADD PRIMARY KEY (`Textile_ID1`,`Starting/Finishing_Border_ID`),
  ADD KEY `Starting/Finishing_Border_ID1_idx` (`Starting/Finishing_Border_ID`),
  ADD KEY `Stitching_name6_idx` (`Stiching_name6`),
  ADD KEY `Thread_ID6_idx` (`Thread_ID6`);

--
-- Indizes für die Tabelle `textile_structural_feature`
--
ALTER TABLE `textile_structural_feature`
  ADD PRIMARY KEY (`Textile_ID9`,`Structural_feature_name1`),
  ADD KEY `Structural_feature_name1_idx` (`Structural_feature_name1`);

--
-- Indizes für die Tabelle `weave`
--
ALTER TABLE `weave`
  ADD PRIMARY KEY (`Weave_name`);

--
-- Indizes für die Tabelle `weave_thickness`
--
ALTER TABLE `weave_thickness`
  ADD PRIMARY KEY (`weave_thickness`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `embroidery`
--
ALTER TABLE `embroidery`
  MODIFY `Embroidery_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `embridery_stitch_stitching_thread`
--
ALTER TABLE `embridery_stitch_stitching_thread`
  ADD CONSTRAINT `Embroidery_ID1` FOREIGN KEY (`Embrodery_ID1`) REFERENCES `embroidery` (`Embroidery_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Stitch_name4` FOREIGN KEY (`Stitch_name4`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID4` FOREIGN KEY (`Thread_ID4`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `embroidery`
--
ALTER TABLE `embroidery`
  ADD CONSTRAINT `Textile_ID7` FOREIGN KEY (`Textile_ID7`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `reparation`
--
ALTER TABLE `reparation`
  ADD CONSTRAINT `Stitch_name3` FOREIGN KEY (`Stitch_name3`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID6` FOREIGN KEY (`Textile_ID6`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID3` FOREIGN KEY (`Thread_ID3`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `tapestry`
--
ALTER TABLE `tapestry`
  ADD CONSTRAINT `Textile_ID8` FOREIGN KEY (`Textile_ID8`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Weave_name1` FOREIGN KEY (`Weave_name1`) REFERENCES `weave` (`Weave_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `tapestry_tapestry_feature`
--
ALTER TABLE `tapestry_tapestry_feature`
  ADD CONSTRAINT `Tapestry_ID1` FOREIGN KEY (`Tapestry_ID1`) REFERENCES `tapestry` (`Tapestry_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Tapestry_feature_name1` FOREIGN KEY (`Tapestry_feature_name1`) REFERENCES `tapestry_feature` (`Tapestry_feature_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile`
--
ALTER TABLE `textile`
  ADD CONSTRAINT `Ground_weave` FOREIGN KEY (`Ground_weave`) REFERENCES `weave` (`Weave_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Perceived_thickness` FOREIGN KEY (`Perceived_thickness`) REFERENCES `weave_thickness` (`weave_thickness`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_Item_ID1` FOREIGN KEY (`Textile_Item_ID1`) REFERENCES `textile_item` (`Textile_Item_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Warp_spin_tightness` FOREIGN KEY (`Warp_spin_tightness`) REFERENCES `spin_tightness` (`Spin_tightness`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Weft_spin_tightness` FOREIGN KEY (`Weft_spin_tightness`) REFERENCES `spin_tightness` (`Spin_tightness`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_hem`
--
ALTER TABLE `textile_hem`
  ADD CONSTRAINT `Hem_ID1` FOREIGN KEY (`Hem_ID1`) REFERENCES `hem` (`Hem_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Stitch_name2` FOREIGN KEY (`Stitch_name2`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID5` FOREIGN KEY (`Textile_ID5`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID2` FOREIGN KEY (`Thread_ID2`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_seam`
--
ALTER TABLE `textile_seam`
  ADD CONSTRAINT `Stitch_name1` FOREIGN KEY (`Stitch_name1`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID3` FOREIGN KEY (`Textile_ID3`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID4` FOREIGN KEY (`Textile_ID4`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID1` FOREIGN KEY (`Thread_ID1`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_selvedge`
--
ALTER TABLE `textile_selvedge`
  ADD CONSTRAINT `Selvedge_ID1` FOREIGN KEY (`Selvedge_ID1`) REFERENCES `selvedge` (`Selvedge_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Stitch_name5` FOREIGN KEY (`Stitch_name5`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID2` FOREIGN KEY (`Textile_ID2`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID5` FOREIGN KEY (`Thread_ID5`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_sewing`
--
ALTER TABLE `textile_sewing`
  ADD CONSTRAINT `Textile_ID10` FOREIGN KEY (`Textile_ID10`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_starting/finishing_border`
--
ALTER TABLE `textile_starting/finishing_border`
  ADD CONSTRAINT `Starting/Finishing_Border_ID1` FOREIGN KEY (`Starting/Finishing_Border_ID`) REFERENCES `starting/finishing_border` (`Starting/Finishing_Border_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Stitching_name6` FOREIGN KEY (`Stiching_name6`) REFERENCES `stitch` (`Stitch_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID1` FOREIGN KEY (`Textile_ID1`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Thread_ID6` FOREIGN KEY (`Thread_ID6`) REFERENCES `stitching_thread` (`Thread_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `textile_structural_feature`
--
ALTER TABLE `textile_structural_feature`
  ADD CONSTRAINT `Structural_feature_name1` FOREIGN KEY (`Structural_feature_name1`) REFERENCES `structural_feature` (`Structural_feature_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Textile_ID9` FOREIGN KEY (`Textile_ID9`) REFERENCES `textile` (`Textile_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
