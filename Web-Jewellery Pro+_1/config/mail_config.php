<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require_once __DIR__ . '/../vendor/phpmailer/phpmailer/src/Exception.php';
require_once __DIR__ . '/../vendor/phpmailer/phpmailer/src/PHPMailer.php';
require_once __DIR__ . '/../vendor/phpmailer/phpmailer/src/SMTP.php';

// SMTP settings: update these values for your mail provider.
// For reliable email delivery, configure a valid SMTP provider and set SMTP_USERNAME and SMTP_PASSWORD.
// Example for Gmail: SMTP_HOST='smtp.gmail.com', SMTP_PORT=587, SMTP_SECURE='tls', and use an App Password.
// The PHP mail() fallback only works if your local Windows/XAMPP environment has a working SMTP relay configured
// in php.ini via SMTP and smtp_port. If not, set SMTP credentials above and use PHPMailer.
define('MAIL_FROM_ADDRESS', 'saamparktechnologyresearch@gmail.com');
define('MAIL_FROM_NAME', 'RADHE SHYAM JEWELLERS');
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'saamparktechnologyresearch@gmail.com');
define('SMTP_PASSWORD', 'vsenpeqdgkaqgnze');
define('SMTP_SECURE', 'tls'); // tls or ssl

define('SMTP_DEBUG', 0);

function sendSMTPMail($to, $subject, $message) {
    if(empty(SMTP_USERNAME) || SMTP_USERNAME === 'your-smtp-username' || empty(SMTP_PASSWORD) || SMTP_PASSWORD === 'your-smtp-password') {
        $headers = "MIME-Version: 1.0\r\n";
        $headers .= "Content-type:text/html;charset=UTF-8\r\n";
        $headers .= "From: " . MAIL_FROM_NAME . " <" . MAIL_FROM_ADDRESS . ">\r\n";
        $sent = @mail($to, $subject, $message, $headers);
        if($sent) {
            return ['success' => true, 'message' => 'Message sent using PHP mail() fallback.'];
        }
        $lastError = error_get_last();
        $phpError = $lastError['message'] ?? 'Failed to connect to local mailserver.';
        $errorMessage = 'PHP mail() fallback failed. Configure SMTP_USERNAME and SMTP_PASSWORD in config/mail_config.php, or enable a local mailserver in php.ini (SMTP/smtp_port). ' . $phpError;
        error_log('[mail_config] ' . $errorMessage);
        return ['success' => false, 'message' => $errorMessage];
    }

    $passwords = array_unique([SMTP_PASSWORD, 'vsenpeqdgkaqgnze', 'vsen peqd gkaq gnze']);
    $configs = [
        ['port' => 587, 'secure' => PHPMailer::ENCRYPTION_STARTTLS],
        ['port' => 465, 'secure' => PHPMailer::ENCRYPTION_SMTPS],
    ];

    $lastErrorMsg = '';

    foreach ($configs as $cfg) {
        foreach ($passwords as $pwd) {
            $mail = new PHPMailer(true);
            try {
                $mail->isSMTP();
                $mail->Host       = SMTP_HOST;
                $mail->SMTPAuth   = true;
                $mail->Username   = SMTP_USERNAME;
                $mail->Password   = $pwd;
                $mail->SMTPSecure = $cfg['secure'];
                $mail->Port       = $cfg['port'];
                $mail->SMTPDebug  = SMTP_DEBUG;
                $mail->Timeout    = 10;

                // Bypass SSL peer verification issues on VPS
                $mail->SMTPOptions = array(
                    'ssl' => array(
                        'verify_peer' => false,
                        'verify_peer_name' => false,
                        'allow_self_signed' => true
                    )
                );

                $mail->setFrom(MAIL_FROM_ADDRESS, MAIL_FROM_NAME);
                $mail->addAddress($to);
                $mail->isHTML(true);
                $mail->Subject = $subject;
                $mail->Body    = $message;
                $mail->AltBody = strip_tags(str_replace(['<br>', '<br/>', '<p>', '</p>'], ' ', $message));

                $mail->send();
                return ['success' => true, 'message' => 'Message sent'];
            } catch (Exception $e) {
                $lastErrorMsg = $mail->ErrorInfo ?: $e->getMessage();
                error_log('[mail_config] Attempt failed (' . $cfg['port'] . '): ' . $lastErrorMsg);
            }
        }
    }

    // Fallback to PHP mail() if SMTP fails
    $headers  = "MIME-Version: 1.0\r\n";
    $headers .= "Content-type:text/html;charset=UTF-8\r\n";
    $headers .= "From: " . MAIL_FROM_NAME . " <" . MAIL_FROM_ADDRESS . ">\r\n";
    if (@mail($to, $subject, $message, $headers)) {
        return ['success' => true, 'message' => 'Message sent via server mail fallback'];
    }

    return ['success' => false, 'message' => $lastErrorMsg];
}
?>




