# !/usr/local/bin/python
# -*- coding: utf-8 -*-

import open_bci_v3
import time
import filters
import time
import csv
import numpy as np
import open_bci_v3 as bci
import udp_server

class Data_Buffer():

	def __init__(self):
		self.filt = filters.Filters()
		self.data_buffer = []
		self.count = 0
		self.udp_packet = []

	def buffer(self,sample):
		count = 0;
		if sample and ((count%8) == 0):
			EEG = []
			EEG = self.filt.filter_data(sample)
			send = []

			if (EEG is not None) and (count%4==0):
				uv = EEG[0]
				fft = EEG[1]
				fft1 = fft[0,10:42]
				fft2 = fft[9,10:42]

				for chan in uv:
					send.append(chan[0])
				for pt in fft1:
					send.append(pt)
				for pt in fft2:
					send.append(pt)
				# print(np.shape(send))
				# print(send)
				udp.receive(send)

		# DATA FORMAT
		# FIRST 18 values are from the raw voltage
		# 0-5: subj 1 eeg
		# 6: subj 1 ecg
		# 7: null
		# 8-13: subj2 eeg
		# 14: subj2 ecg
		# 15: null
		# 16-2080: channels 0-5 and 8-13 fft data (129 points per channel)
		self.count = self.count+1

def playback(db):
	'''
	Plays back recorded files from the aaron_test_data folder.
	Uncomment the file you want to use.
	'''

	# filtered_data
	# test_file = 'aaron_test_data/Filtered_Data/RAW_eeg_data_only_FILTERED.txt'
	# test_file = 'aaron_test_data/Filtered_Data/RAW_eeg_ecg_data_only(ecg_isolated)_FILTERED.txt'
	# test_file = 'aaron_test_data/Filtered_Data/RAW_eeg_ecg_data_only(eeg_isolated)_FILTERED.txt'

	# RAW_Data_only
	test_file = 'aaron_test_data/RAW_data_only/RAW_eeg_data_only.txt'
	# test_file = 'aaron_test_data/RAW_data_only/RAW_eeg_ecg_data_only.txt'
	# test_file = 'aaron_test_data/RAW_data_only/RAW_eeg_ecg_data_only(ecg_isolated).txt'
	# test_file = 'aaron_test_data/RAW_data_only/RAW_eeg_ecg_data_only(eeg_isolated).txt'

	# RAW_output
	# test_file = 'aaron_test_data/RAW_output/RAW_eeg_ecg.txt'
	# test_file = 'aaron_test_data/RAW_output/RAW_eeg.txt'

	# test_file = 'aaron_test_data/SavedData\OpenBCI-RAW-aaron+eva.txt'
	# test_file = 'aaron_test_data/SavedData\OpenBCI-RAW-friday_test.txt'

	channel_data = []

	with open(test_file, 'r') as file:
		reader = csv.reader(file, delimiter=',')
		for j, line in enumerate(reader):
			if '%' not in line[0] :
				line = [x.replace(' ','') for x in line]
				channel_data.append(line) #list


	print 'Loaded {0} channel lines from {1}'.format(len(channel_data), test_file)

	last_time_of_program = 0
	start = time.time()
	for i,sample in enumerate(channel_data):
		end = time.time()
		#Mantain the 250 Hz sample rate when reading a file
		#Wait for a period of time if the program runs faster than real time
		time_of_recording = i/250
		time_of_program = end-start
		# print('i/250 (time of recording)', time_of_recording)
		# print('comp timer (time of program)', time_of_program)
		if time_of_recording > time_of_program:
			# print('PAUSING ', time_of_recording-time_of_program, ' Seconds')
			time.sleep(time_of_recording-time_of_program)
		db.buffer(sample)

def main():
	print 'Starting UDP server'
	global udp
	udp = udp_server.UDPServer()

	db = Data_Buffer()
	# board = bci.OpenBCIBoard(port='/dev/ttyUSB0', send=db)
	# board.start_streaming(db.buffer)

	playback(db)

if __name__ == '__main__':
	main()
