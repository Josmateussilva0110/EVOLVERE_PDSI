function formatMessageSendPassword(resetLink) {
    const html = `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; border: 1px solid #e0e0e0; padding: 20px; border-radius: 10px; background-color: #ffffff;">
            <div style="text-align: center;">
                <h2 style="color: #4CAF50;">🔐 Redefinir sua senha</h2>
            </div>

            <p style="font-size: 16px; color: #333;">Olá,</p>
            
            <p style="font-size: 16px; color: #333;">
                Recebemos uma solicitação para redefinir sua senha na <strong>Evolvere</strong>.
            </p>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="${resetLink}" style="
                    background-color: #4CAF50;
                    color: white;
                    padding: 14px 24px;
                    text-decoration: none;
                    border-radius: 8px;
                    display: inline-block;
                    font-weight: bold;
                    font-size: 16px;
                ">
                    🔑 Redefinir Senha
                </a>
            </div>
            
            <p style="font-size: 16px; color: #333;">
                Se preferir, copie e cole o link abaixo no seu navegador:
            </p>

            <p style="word-break: break-all; font-size: 14px;">
                <a href="${resetLink}" style="color: #4CAF50;">${resetLink}</a>
            </p>

            <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">

            <p style="font-size: 12px; color: #888;">
                Você recebeu este e-mail porque foi solicitada uma redefinição de senha na <strong>Evolvere</strong>.<br>
                Se não foi você, pode ignorar esta mensagem com segurança.<br><br>
                Obrigado,<br>
                Equipe Evolvere
            </p>
        </div>
    `;

    return { html };
}

module.exports = formatMessageSendPassword;
