def return_opcode(opcode,line):
	s=line.split(" ",1)
	if(s[0] in opcode.keys()):
		return opcode[s[0]]


def cnt_opcode(line,opcode):
	l=line.split()
	cnt=0
	opcode_list=opcode.keys()
	for i in l:
		if(i in opcode_list):
			cnt+=1
	return cnt


def isOpcode(opcode,op):
	if(op in opcode.keys()):
		return True
	else:
		return False


def pass1(error,opcode,symbols):
	file=open("input.txt","r")   		
	lc=0
	lineno=0
	while(True):
		flag=True
		line=file.readline()
		if not line:
			break
		else:
			eof=line.find('/n')
			if(eof!=-1 and flag):
				line=line[:-1]
			lineno+=1
			comment=line.find('//')
			if(comment!=-1 and flag):
				line=line[:comment]				
			if(line!='' and flag):
				brz=line.find('BRZ')
				brp=line.find('BRP')
				brn=line.find('BRN')
				inp=line.find('INP')
				sac=line.find('SAC')
				stp=line.find('STP')
				if(line.strip()=='STP' and flag):
					lc+=1
					break
				if(cnt_opcode(line,opcode)==0 and flag):
					error=True
					flag=False
					print(line)
					print("Error found on line number "+str(lineno)+": No Opcode found.")
				if(cnt_opcode(line,opcode)>1 and flag):
					error=True
					flag=False
					print("Error found on line number "+str(lineno)+": More than one Opcode found.")
				l=line.split()
				n = len(l)
				if(n==1 and l[0]!='CLA' and l[0]!='STP' and flag):
					error=True
					flag=False
					print("Error found on line number "+str(lineno)+": Insufficient no. of arguments.")
				if(n==2 and isOpcode(opcode,l[0])==False and isOpcode(opcode,l[1])==True and l[1]!='CLA' and l[1]!='STP' and flag):
					error=True
					flag=False
					print("Error found on line number "+str(lineno)+": Formatting Error")
				for k in range(n):
					q=False
					if(l[k] in opcode.keys()):
						q=True
					if(q==True):
						if(n-k-1>=2):
							error=True	
							flag=False
							print("ERROR on Line "+str(lineno)+": More than one variable/label provided.")	
				if(n>=3 and isOpcode(opcode,l[0])==False and isOpcode(opcode,l[1])==False and flag):
					error=True
					flag=False
					print("Error found on line number "+str(lineno)+": Formatting Error")
				colon=line.find(':')
				if(colon!=-1 and flag):
					label=line[:colon]
					label=label.strip()
					if(isOpcode(opcode,label)):
						error=True
						flag=False
						print("Error found on line number "+str(lineno)+": Label cannot be a opcode.")
					if(label in symbols and symbols[label]==-1 and flag):
						error=True
						flag=False
						print("Error found on line number "+str(lineno)+": Same symbol defined more than one time.")
					if(stp!=-1):
						symbols[label]=lc
						lc+=1
						continue
					symbols[label]=lc
				elif(brz!=-1 or brp!=-1 or brn!=-1 and flag):
					head=l[1]
					head=head.strip()
					if(isOpcode(opcode,head)):
						error=True
						flag=False
						print("Error found on line number "+str(lineno)+": Symbol cannot be a opcode.")
					if(head in symbols and flag):
						if(symbols[head]==-1):
							error=True
							flag=False
							print("Error found on line number "+str(lineno)+":"+head+" is a label type symbol.")
						else:
							lc+=1
							continue
					else:
						symbols[head]=-2
				elif(sac!=-1 or inp!=-1 and flag):
					head=l[1]
					head=head.strip()
					if(isOpcode(opcode,head)):
						error=True
						flag=False
						print("Error found on line number "+str(lineno)+": Symbol cannot be a opcode.")
					if(head in symbols and flag):
						if(symbols[head]==-1):
							error=True
							flag=False
							print("Error found on line number "+str(lineno)+":"+head+" is a label type symbol.")
					symbols[head]=-1
				lc+=1
	symbolsName=list(symbols)
	nvar=0
	for i in range(len(symbols)):
		if(symbols[symbolsName[i]]==-2):
			print("Error: Label not defined "+symbolsName[i])
			error=True
		elif(symbols[symbolsName[i]]==-1):
			nvar+=1
			symbols[symbolsName[i]]=lc
			lc+=1
	nlines=lc-nvar
	if(nlines+nvar>256):
		print("Error: Number of instructions has been exceeded than the limit-(0-255).")
	file.close()    

	return error,symbols,nlines	


def pass2(opcode,symbols,nlines):
	for symbol in symbols.keys():
		value=symbols[symbol]
		binaryvalue=format(value,'08b')
		symbols[symbol]=binaryvalue
	mcode=open("machinecode.txt",'w')
	file=open("input.txt","r")
	while(True):
		line=file.readline()
		if not line:
			break
		else:
			eof=line.find('/n')
			if(eof!=-1):
				line=line[:-1]
			comment=line.find('//')
			if(comment!=-1):
				line=line[:comment]				
			if(line!=''):
				colon=line.find(':')
				if(colon!=-1):
					line=line[colon+1:]
				l=line.split()    
				if(len(l)==1):
					mcode.write(return_opcode(opcode,l[0])+" 00000000"+'\n')
				else:
					mcode.write(return_opcode(opcode,l[0])+" "+str(symbols[l[1]])+'\n')
	vtable=open("VariableTable.txt",'w')
	vtable.write("VARIABLE\tADDRESS"+'\n')
	ltable=open("LabelTable.txt",'w')
	ltable.write("LABEL\t\tADDRESS"+'\n')
	symbolskeys=symbols.keys()
	for i in symbolskeys:
		if(int(symbols[i],2)<nlines):
			ltable.write(i+'\t\t\t'+symbols[i]+'\n')
		else:
			vtable.write(i+'\t\t\t'+symbols[i]+'\n')
	ltable.close()
	mcode.close()
	file.close()
	vtable.close()


opcode={"CLA":"0000","LAC":"0001","SAC":"0010","ADD":"0011","SUB":"0100","BRZ":"0101","BRN":"0110","BRP":"0111","INP":"1000","DSP":"1001","MUL":"1010","DIV":"1011","STP":"1100"}
symbols={}
error=False
error,symbols,nlines=pass1(error,opcode,symbols)
print(symbols)
print(nlines)
if(error==False):
	pass2(opcode,symbols,nlines)
else:
	exit()