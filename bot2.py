import discord
from discord.ext import commands
import asyncio
import random

# Intents 설정
intents = discord.Intents.all()
intents.messages = True  # 메시지 관련 이벤트 수신 설정
intents.guilds = True    # 서버 관련 이벤트 수신 설정 필요 시

# 봇 생성
bot = commands.Bot(command_prefix='.', intents=intents)

@bot.command()
async def survey(ctx):
    survey_link = 'https://example.com/survey'  # 설문조사 링크를 여기에 넣으세요.
    await ctx.send(f'여기에서 설문조사에 참여하세요: {survey_link}')
# !ping 명령어를 처리하는 커맨드
@bot.command()
async def ping(ctx):
    await ctx.send('Pong!')

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user}')
    bot.loop.create_task(send_random_message())

@bot.event
async def on_error(event, *args, **kwargs):
    print(f"Error in event {event}: {args} {kwargs}")

async def send_random_message():
    channel_id = 1276845120083198004  # 채널 ID 입력
    message = "여기에 전송할 메시지와 링크를 입력하세요"
    while True:
        try:
            channel = bot.get_channel(channel_id)
            if channel is None:
                print(f"채널 ID {channel_id}를 찾을 수 없습니다.")
                await asyncio.sleep(60)  # 1분 대기 후 재시도
                continue
            delay = random.randint(3600, 86400)  # 1시간에서 24시간 사이 랜덤
            await asyncio.sleep(delay)
            await channel.send(message)
            print(f"메시지 전송 완료: {message}")
        except Exception as e:
            print(f"메시지 전송 중 오류 발생: {e}")
            await asyncio.sleep(60)  # 1분 대기 후 재시도

# 토큰을 코드에 직접 넣지 말고 환경 변수나 외부 설정 파일을 통해 관리하는 것이 좋습니다.
bot.run('MTI3Njg0NTEyMDA4MzE5ODAwNA.GjcCbE.vCygZn25NZ8Ipanw')
