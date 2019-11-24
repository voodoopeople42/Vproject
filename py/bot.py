import TeleBot

bot = telebot.Telebot("671322895:AAGI2APIeBHWI6SNU_qm1F1sECD0Ih_05VU")

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
	bot.reply_to(message, message.text)