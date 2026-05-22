-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 22, 2026 at 10:39 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hireflowjee`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL,
  `action` varchar(255) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `timestamp` datetime(6) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`log_id`, `action`, `details`, `timestamp`, `user_id`, `username`) VALUES
(1, 'LOGIN', 'User logged into the platform', '2026-05-05 00:52:10.000000', 17, 'saad'),
(2, 'LOGIN', 'User logged into the platform', '2026-05-05 00:52:48.000000', 25, 'admin'),
(3, 'LOGIN', 'User logged into the platform', '2026-05-05 00:56:40.000000', 25, 'admin'),
(4, 'LOGIN', 'User logged into the platform', '2026-05-05 00:58:47.000000', 25, 'admin'),
(5, 'LOGIN', 'User logged into the platform', '2026-05-05 00:59:42.000000', 25, 'admin'),
(6, 'LOGIN', 'User logged into the platform', '2026-05-05 01:07:33.000000', 25, 'admin'),
(7, 'LOGIN', 'User logged into the platform', '2026-05-05 01:38:31.000000', 25, 'admin'),
(8, 'LOGIN', 'User logged into the platform', '2026-05-05 01:38:36.000000', 25, 'admin'),
(9, 'LOGIN', 'User logged into the platform', '2026-05-05 01:44:43.000000', 22, 'hamma'),
(10, 'LOGIN', 'User logged into the platform', '2026-05-05 01:45:13.000000', 20, 'free'),
(11, 'LOGIN', 'User logged into the platform', '2026-05-05 01:45:26.000000', 20, 'free'),
(12, 'LOGIN', 'User logged into the platform', '2026-05-05 01:50:35.000000', 17, 'saad'),
(13, 'LOGIN', 'User logged into the platform', '2026-05-05 01:50:47.000000', 21, 'ali'),
(14, 'LOGIN', 'User logged into the platform', '2026-05-05 01:51:02.000000', 20, 'free'),
(15, 'LOGIN', 'User logged into the platform', '2026-05-05 14:42:22.000000', 25, 'admin'),
(16, 'LOGIN', 'User logged into the platform', '2026-05-05 14:42:50.000000', 19, 'yosr'),
(17, 'LOGIN', 'User logged into the platform', '2026-05-05 14:43:06.000000', 22, 'hamma'),
(18, 'LOGIN', 'User logged into the platform', '2026-05-05 14:45:39.000000', 17, 'saad'),
(19, 'LOGIN', 'User logged into the platform', '2026-05-05 14:45:46.000000', 22, 'hamma'),
(20, 'APPLY', 'Applied to job ID 37', '2026-05-05 14:45:55.000000', 22, 'hamma'),
(21, 'LOGIN', 'User logged into the platform', '2026-05-05 14:46:03.000000', 17, 'saad'),
(22, 'LOGIN', 'User logged into the platform', '2026-05-05 14:49:02.000000', 25, 'admin'),
(23, 'LOGIN', 'User logged into the platform', '2026-05-05 15:28:05.000000', 22, 'hamma'),
(24, 'LOGIN', 'User logged into the platform', '2026-05-05 15:28:45.000000', 17, 'saad'),
(25, 'LOGIN', 'User logged into the platform', '2026-05-05 18:45:38.000000', 17, 'saad'),
(26, 'LOGIN', 'User logged into the platform', '2026-05-05 19:21:58.000000', 22, 'hamma'),
(27, 'LOGIN', 'User logged into the platform', '2026-05-05 19:26:16.000000', 17, 'saad'),
(28, 'REJECT_APPLICATION', 'Rejected application ID 23 for job ID 36', '2026-05-05 19:27:44.000000', 17, 'saad');

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `application_id` int(11) NOT NULL,
  `freelancer_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `status` enum('PENDING','ACCEPTED','REJECTED') DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `rating` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`application_id`, `freelancer_id`, `post_id`, `status`, `created_at`, `rating`) VALUES
(1, 19, 8, 'REJECTED', '2026-04-17 21:57:41', NULL),
(2, 19, 7, 'ACCEPTED', '2026-04-17 21:57:42', 5),
(3, 19, 9, 'ACCEPTED', '2026-04-17 23:07:16', 4),
(4, 19, 10, 'REJECTED', '2026-04-17 23:11:55', NULL),
(5, 19, 12, 'ACCEPTED', '2026-04-19 12:14:23', 1),
(6, 19, 13, 'ACCEPTED', '2026-04-19 13:56:31', 3),
(7, 19, 11, 'REJECTED', '2026-04-19 14:16:23', NULL),
(8, 20, 10, 'ACCEPTED', '2026-04-19 14:23:45', 5),
(9, 19, 14, 'ACCEPTED', '2026-04-19 14:43:02', 5),
(10, 19, 15, 'ACCEPTED', '2026-04-19 14:56:02', 2),
(11, 19, 16, 'ACCEPTED', '2026-04-19 15:00:17', 3),
(12, 19, 17, 'ACCEPTED', '2026-04-19 15:16:02', 3),
(13, 19, 18, 'REJECTED', '2026-04-19 22:37:50', NULL),
(14, 22, 21, 'ACCEPTED', '2026-04-21 13:00:19', 4),
(15, 19, 19, 'REJECTED', '2026-04-27 18:11:32', NULL),
(16, 19, 22, 'ACCEPTED', '2026-04-27 18:30:21', 1),
(17, 23, 8, 'ACCEPTED', '2026-04-27 18:36:39', 5),
(18, 23, 19, 'PENDING', '2026-04-27 18:36:41', NULL),
(19, 23, 22, 'REJECTED', '2026-04-27 18:36:42', NULL),
(20, 23, 11, 'PENDING', '2026-04-27 18:36:43', NULL),
(21, 19, 34, 'PENDING', '2026-05-04 10:24:20', NULL),
(22, 23, 37, 'REJECTED', '2026-05-04 22:09:14', NULL),
(23, 23, 36, 'REJECTED', '2026-05-04 22:22:58', NULL),
(24, 22, 37, 'PENDING', '2026-05-05 13:45:55', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `budget` double NOT NULL,
  `status` enum('OPEN','IN_PROGRESS','CLOSED') DEFAULT 'OPEN',
  `client_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`post_id`, `title`, `description`, `budget`, `status`, `client_id`, `created_at`) VALUES
(7, 'nheb site web', 'site fih barcha fazet', 450, 'CLOSED', 17, '2026-04-17 20:49:17'),
(8, 'react dashboard', 'dashboard admin bras omk', 1000, 'CLOSED', 17, '2026-04-17 20:49:48'),
(9, 'aaaaa', 'nooooooo', 500, 'CLOSED', 17, '2026-04-17 22:28:58'),
(10, 'test pending', 'test', 10, 'CLOSED', 17, '2026-04-17 23:11:39'),
(11, 'test rating', 'rating', 120, 'OPEN', 17, '2026-04-19 12:06:00'),
(12, 'test8', 'tes8', 600, 'CLOSED', 17, '2026-04-19 12:07:14'),
(13, 'test9', 'test5', 200, 'CLOSED', 17, '2026-04-19 13:56:18'),
(14, 'test10', 'test10', 56, 'CLOSED', 17, '2026-04-19 14:41:44'),
(15, 'test11', 'test11', 562, 'CLOSED', 17, '2026-04-19 14:55:50'),
(16, 'tst12', 'tt', 563, 'CLOSED', 17, '2026-04-19 15:00:02'),
(17, 'test12', 'r21', 220, 'CLOSED', 17, '2026-04-19 15:15:25'),
(18, 'test13', '1313', 588, 'OPEN', 17, '2026-04-19 22:37:39'),
(19, 'test14', '1414', 485, 'OPEN', 17, '2026-04-19 22:38:09'),
(21, 'Application Web', 'JEE', 70, 'CLOSED', 21, '2026-04-21 12:58:28'),
(22, 'testAAAAAAA', 'AAAA', 650, 'CLOSED', 17, '2026-04-27 18:08:59'),
(23, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-28 20:19:20'),
(24, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-28 20:19:53'),
(25, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 12:46:15'),
(26, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:07:00'),
(27, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:09:14'),
(28, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:10:12'),
(29, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:10:32'),
(30, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:24:42'),
(31, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:27:01'),
(32, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:29:38'),
(33, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:31:43'),
(34, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:37:04'),
(35, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:39:57'),
(36, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 13:42:09'),
(37, 'pytest job', 'just ntesti fel ISTQB', 100, 'OPEN', 17, '2026-04-29 14:07:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `email` varchar(255) DEFAULT NULL,
  `bio` longtext DEFAULT NULL,
  `skills` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `name`, `address`, `role`, `created_at`, `email`, `bio`, `skills`) VALUES
(17, 'saad', '7c1a4a1d4b462cb7b767e6d653440877683f11b5c1b069717c1fe75b5fc605ab', 'saad', '', 'CLIENT', '2026-04-17 20:47:39', 'saad@gmail.com', NULL, NULL),
(18, 'aziz', '5705a82920cee05ca634e8a82a2a11be30aa0d655c7b87a67d48b828e8e46144', 'aziz', NULL, 'CLIENT', '2026-04-17 20:50:12', NULL, NULL, NULL),
(19, 'yosr', '449bfcaf3104f235a51785e77f9c0d7f16c522ddfc3a834e8748a298fa947477', 'yosr', NULL, 'FREELANCER', '2026-04-17 21:01:18', NULL, NULL, NULL),
(20, 'free', 'ad95d5fa651ba86d8923fe1238d24a4f1988a752acfe426ac72ac7c04471bc17', 'free', '', 'FREELANCER', '2026-04-19 14:23:34', 'free@gmail.com', NULL, NULL),
(21, 'ali', '94419b99b12c11133a4dfeccc3e17885974beb48f7827c48239aabfbcad238d8', 'ali', NULL, 'CLIENT', '2026-04-21 12:57:56', NULL, NULL, NULL),
(22, 'hamma', '00479579620997076d534960a8dbd68480af1d9e0e602227034f25e7b85a363d', 'hamma', '', 'FREELANCER', '2026-04-21 12:59:34', 'hamma@gmail.com', NULL, NULL),
(23, 'menyar', '793d60aea3f133664d3dcd2ba979117854632ff35a27e639a1421f4bfac19a80', 'menyar', '', 'FREELANCER', '2026-04-27 18:36:14', 'menyar@gmail.com', 'A dedicated IT analyst with 3 years of experience, I specialize in Java, Python, HTML, CSS, JavaScript, Power BI, Excel, and cybersecurity. My keen analytical skills and technical expertise helped a company enhance its server defenses by 50%. Passionate about leveraging technology to solve complex problems, I am committed to delivering high-quality results that drive business success. Letâs work together to elevate your projects with my skill set and experience.', 'java,python,html,css,js,power bi,excel,cybersecurity'),
(24, 'client', '948fe603f61dc036b5c596dc09fe3ce3f3d30dc90f024c85f3c82db2ccab679d', 'client', NULL, 'CLIENT', '2026-04-29 14:11:57', NULL, NULL, NULL),
(25, 'admin', '7c1a4a1d4b462cb7b767e6d653440877683f11b5c1b069717c1fe75b5fc605ab', 'System Administrator', '', 'ADMIN', '2026-05-04 22:41:09', 'admin@admin.com', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`log_id`);

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`application_id`),
  ADD UNIQUE KEY `UKjqvyp8fkdyww37h7v4s5dxyck` (`freelancer_id`,`post_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`post_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `application_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `post_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`freelancer_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
