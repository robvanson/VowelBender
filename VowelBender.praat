#! praat
# 
# Shape formant tracks in speech and synthesizes the result.
# Specifically designed to change the shape of vowel space.
#
# Unless specified otherwise:
#
# Copyright: 2025-2026, R.J.J.H. van Son and the Netherlands Cancer Institute
# License: GNU AFFERO GENERAL PUBLIC LICENSE version 3 or later
# email: r.j.j.h.vanson@gmail.com, r.v.son@nki.nl
# 
#     VowelBender.praat: Praat script to change and synthesize formant tracks in speech
#     
#     Copyright (C) 2026  R.J.J.H. van Son and the Netherlands Cancer Institute
# 
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
# 

sourceDir$ = "../Speech/"
targetDir$ = ""

defaultSourceSignal$ = "Phonation"
targetFormantAlgorithm$ = "Robust"

# Generate VowelTriangle non-interactive table
vowelBenderLogFile$ = "../Test/VowelBenderLog.csv"
writeLog = 1

###############################################
#
# Burg's method formant algorithm (Burg)
#
###############################################

# Male 
phonemes ["Burg", "M", "A", "F1"] = 743
phonemes ["Burg", "M", "A", "F2"] = 1075
phonemes ["Burg", "M", "E", "F1"] = 572
phonemes ["Burg", "M", "E", "F2"] = 1802
phonemes ["Burg", "M", "I", "F1"] = 383
phonemes ["Burg", "M", "I", "F2"] = 2037
phonemes ["Burg", "M", "O", "F1"] = 499
phonemes ["Burg", "M", "O", "F2"] = 712
phonemes ["Burg", "M", "Y", "F1"] = 425
phonemes ["Burg", "M", "Y", "F2"] = 1482
phonemes ["Burg", "M", "Y:", "F1"] = 388
phonemes ["Burg", "M", "Y:", "F2"] = 1514
phonemes ["Burg", "M", "a", "F1"] = 837
phonemes ["Burg", "M", "a", "F2"] = 1299
phonemes ["Burg", "M", "au", "F1"] = 606
phonemes ["Burg", "M", "au", "F2"] = 962
phonemes ["Burg", "M", "e", "F1"] = 376
phonemes ["Burg", "M", "e", "F2"] = 2117
phonemes ["Burg", "M", "ei", "F1"] = 513
phonemes ["Burg", "M", "ei", "F2"] = 1855
phonemes ["Burg", "M", "i", "F1"] = 261
phonemes ["Burg", "M", "i", "F2"] = 2183
phonemes ["Burg", "M", "o", "F1"] = 446
phonemes ["Burg", "M", "o", "F2"] = 721
phonemes ["Burg", "M", "u", "F1"] = 293
phonemes ["Burg", "M", "u", "F2"] = 654
phonemes ["Burg", "M", "ui", "F1"] = 501
phonemes ["Burg", "M", "ui", "F2"] = 1506
phonemes ["Burg", "M", "y", "F1"] = 268
phonemes ["Burg", "M", "y", "F2"] = 1608

# Guessed
phonemes ["Burg", "M", "@", "F1"] = 373
phonemes ["Burg", "M", "@", "F2"] = 1247

# Female
phonemes ["Burg", "F", "A", "F1"] = 878
phonemes ["Burg", "F", "A", "F2"] = 1236
phonemes ["Burg", "F", "E", "F1"] = 685
phonemes ["Burg", "F", "E", "F2"] = 1956
phonemes ["Burg", "F", "I", "F1"] = 435
phonemes ["Burg", "F", "I", "F2"] = 2260
phonemes ["Burg", "F", "O", "F1"] = 584
phonemes ["Burg", "F", "O", "F2"] = 885
phonemes ["Burg", "F", "Y", "F1"] = 504
phonemes ["Burg", "F", "Y", "F2"] = 1674
phonemes ["Burg", "F", "Y:", "F1"] = 437
phonemes ["Burg", "F", "Y:", "F2"] = 1745
phonemes ["Burg", "F", "a", "F1"] = 938
phonemes ["Burg", "F", "a", "F2"] = 1530
phonemes ["Burg", "F", "au", "F1"] = 677
phonemes ["Burg", "F", "au", "F2"] = 1074
phonemes ["Burg", "F", "e", "F1"] = 440
phonemes ["Burg", "F", "e", "F2"] = 2184
phonemes ["Burg", "F", "ei", "F1"] = 633
phonemes ["Burg", "F", "ei", "F2"] = 1951
phonemes ["Burg", "F", "i", "F1"] = 309
phonemes ["Burg", "F", "i", "F2"] = 2341
phonemes ["Burg", "F", "o", "F1"] = 540
phonemes ["Burg", "F", "o", "F2"] = 900
phonemes ["Burg", "F", "u", "F1"] = 391
phonemes ["Burg", "F", "u", "F2"] = 729
phonemes ["Burg", "F", "ui", "F1"] = 632
phonemes ["Burg", "F", "ui", "F2"] = 1655
phonemes ["Burg", "F", "y", "F1"] = 323
phonemes ["Burg", "F", "y", "F2"] = 1803

# Guessed
phonemes ["Burg", "F", "@", "F1"] = 440
phonemes ["Burg", "F", "@", "F2"] = 1415

# Triangle
# Male 
phonemes ["Burg", "M", "i_corner", "F1"] = phonemes ["Burg", "M", "i", "F1"]/(2^(1/12))
phonemes ["Burg", "M", "i_corner", "F2"] = phonemes ["Burg", "M", "i", "F2"]*(2^(1/12))
phonemes ["Burg", "M", "a_corner", "F1"] = phonemes ["Burg", "M", "a", "F1"]*(2^(1/12))
phonemes ["Burg", "M", "a_corner", "F2"] = phonemes ["Burg", "M", "a", "F2"]
phonemes ["Burg", "M", "u_corner", "F1"] = phonemes ["Burg", "M", "u", "F1"]/(2^(1/12))
phonemes ["Burg", "M", "u_corner", "F2"] = phonemes ["Burg", "M", "u", "F2"]/(2^(1/12))
# @_center is not fixed but derived from current corners
phonemes ["Burg", "M", "@_center", "F1"] =(phonemes ["Burg", "M", "i_corner", "F1"]*phonemes ["Burg", "M", "u_corner", "F1"]*phonemes ["Burg", "M", "a_corner", "F1"])^(1/3)
phonemes ["Burg", "M", "@_center", "F2"] = (phonemes ["Burg", "M", "i_corner", "F2"]*phonemes ["Burg", "M", "u_corner", "F2"]*phonemes ["Burg", "M", "a_corner", "F2"])^(1/3)

# Female
phonemes ["Burg", "F", "i_corner", "F1"] = phonemes ["Burg", "F", "i", "F1"]/(2^(1/12))
phonemes ["Burg", "F", "i_corner", "F2"] = phonemes ["Burg", "F", "i", "F2"]*(2^(1/12))
phonemes ["Burg", "F", "a_corner", "F1"] = phonemes ["Burg", "F", "a", "F1"]*(2^(1/12))
phonemes ["Burg", "F", "a_corner", "F2"] = phonemes ["Burg", "F", "a", "F2"]
phonemes ["Burg", "F", "u_corner", "F1"] = phonemes ["Burg", "F", "u", "F1"]/(2^(1/12))
phonemes ["Burg", "F", "u_corner", "F2"] = phonemes ["Burg", "F", "u", "F2"]/(2^(1/12))
# @_center is not fixed but derived from current corners
phonemes ["Burg", "F", "@_center", "F1"] =(phonemes ["Burg", "F", "i_corner", "F1"]*phonemes ["Burg", "F", "u_corner", "F1"]*phonemes ["Burg", "F", "a_corner", "F1"])^(1/3)
phonemes ["Burg", "F", "@_center", "F2"] = (phonemes ["Burg", "F", "i_corner", "F2"]*phonemes ["Burg", "F", "u_corner", "F2"]*phonemes ["Burg", "F", "a_corner", "F2"])^(1/3)

###############################################
#
# Robust formant algorithm (Robust)
#
###############################################

# Male
phonemes ["Robust", "M", "A", "F1"] = 680
phonemes ["Robust", "M", "A", "F2"] = 1038
phonemes ["Robust", "M", "E", "F1"] = 510
phonemes ["Robust", "M", "E", "F2"] = 1900
phonemes ["Robust", "M", "I", "F1"] = 354
phonemes ["Robust", "M", "I", "F2"] = 2167
phonemes ["Robust", "M", "O", "F1"] = 446
phonemes ["Robust", "M", "O", "F2"] = 680
phonemes ["Robust", "M", "Y", "F1"] = 389
phonemes ["Robust", "M", "Y", "F2"] = 1483
phonemes ["Robust", "M", "Y:", "F1"] = 370
phonemes ["Robust", "M", "Y:", "F2"] = 1508
phonemes ["Robust", "M", "a", "F1"] = 797
phonemes ["Robust", "M", "a", "F2"] = 1328
phonemes ["Robust", "M", "au", "F1"] = 542
phonemes ["Robust", "M", "au", "F2"] = 945
phonemes ["Robust", "M", "e", "F1"] = 351
phonemes ["Robust", "M", "e", "F2"] = 2180
phonemes ["Robust", "M", "ei", "F1"] = 471
phonemes ["Robust", "M", "ei", "F2"] = 1994
phonemes ["Robust", "M", "i", "F1"] = 242
phonemes ["Robust", "M", "i", "F2"] = 2330
phonemes ["Robust", "M", "o", "F1"] = 393
phonemes ["Robust", "M", "o", "F2"] = 692
phonemes ["Robust", "M", "u", "F1"] = 269
phonemes ["Robust", "M", "u", "F2"] = 626
phonemes ["Robust", "M", "ui", "F1"] = 475
phonemes ["Robust", "M", "ui", "F2"] = 1523
phonemes ["Robust", "M", "y", "F1"] = 254
phonemes ["Robust", "M", "y", "F2"] = 1609

# Guessed
phonemes ["Robust", "M", "@", "F1"] = 373
phonemes ["Robust", "M", "@", "F2"] = 1247

# Female
phonemes ["Robust", "F", "A", "F1"] = 826
phonemes ["Robust", "F", "A", "F2"] = 1208
phonemes ["Robust", "F", "E", "F1"] = 648
phonemes ["Robust", "F", "E", "F2"] = 2136
phonemes ["Robust", "F", "I", "F1"] = 411
phonemes ["Robust", "F", "I", "F2"] = 2432
phonemes ["Robust", "F", "O", "F1"] = 527
phonemes ["Robust", "F", "O", "F2"] = 836
phonemes ["Robust", "F", "Y", "F1"] = 447
phonemes ["Robust", "F", "Y", "F2"] = 1698
phonemes ["Robust", "F", "Y:", "F1"] = 404
phonemes ["Robust", "F", "Y:", "F2"] = 1750
phonemes ["Robust", "F", "a", "F1"] = 942
phonemes ["Robust", "F", "a", "F2"] = 1550
phonemes ["Robust", "F", "au", "F1"] = 600
phonemes ["Robust", "F", "au", "F2"] = 1048
phonemes ["Robust", "F", "e", "F1"] = 409
phonemes ["Robust", "F", "e", "F2"] = 2444
phonemes ["Robust", "F", "ei", "F1"] = 618
phonemes ["Robust", "F", "ei", "F2"] = 2196
phonemes ["Robust", "F", "i", "F1"] = 271
phonemes ["Robust", "F", "i", "F2"] = 2667
phonemes ["Robust", "F", "o", "F1"] = 470
phonemes ["Robust", "F", "o", "F2"] = 879
phonemes ["Robust", "F", "u", "F1"] = 334
phonemes ["Robust", "F", "u", "F2"] = 686
phonemes ["Robust", "F", "ui", "F1"] = 594
phonemes ["Robust", "F", "ui", "F2"] = 1669
phonemes ["Robust", "F", "y", "F1"] = 285
phonemes ["Robust", "F", "y", "F2"] = 1765

# Guessed
phonemes ["Robust", "F", "@", "F1"] = 440
phonemes ["Robust", "F", "@", "F2"] = 1415

# Triangle
# Male
phonemes ["Robust", "M", "i_corner", "F1"] = phonemes ["Robust", "M", "i", "F1"]/(2^(1/12))
phonemes ["Robust", "M", "i_corner", "F2"] = phonemes ["Robust", "M", "i", "F2"]*(2^(1/12))
phonemes ["Robust", "M", "a_corner", "F1"] = phonemes ["Robust", "M", "a", "F1"]*(2^(1/12))
phonemes ["Robust", "M", "a_corner", "F2"] = phonemes ["Robust", "M", "a", "F2"]
phonemes ["Robust", "M", "u_corner", "F1"] = phonemes ["Robust", "M", "u", "F1"]/(2^(1/12))
phonemes ["Robust", "M", "u_corner", "F2"] = phonemes ["Robust", "M", "u", "F2"]/(2^(1/12))
# @_center is not fixed but derived from current corners
phonemes ["Robust", "M", "@_center", "F1"] =(phonemes ["Robust", "M", "i_corner", "F1"]*phonemes ["Robust", "M", "u_corner", "F1"]*phonemes ["Robust", "M", "a_corner", "F1"])^(1/3)
phonemes ["Robust", "M", "@_center", "F2"] = (phonemes ["Robust", "M", "i_corner", "F2"]*phonemes ["Robust", "M", "u_corner", "F2"]*phonemes ["Robust", "M", "a_corner", "F2"])^(1/3)
                                              
# Female
phonemes ["Robust", "F", "i_corner", "F1"] = phonemes ["Robust", "F", "i", "F1"]/(2^(1/12))
phonemes ["Robust", "F", "i_corner", "F2"] = phonemes ["Robust", "F", "i", "F2"]*(2^(1/12))
phonemes ["Robust", "F", "a_corner", "F1"] = phonemes ["Robust", "F", "a", "F1"]*(2^(1/12))
phonemes ["Robust", "F", "a_corner", "F2"] = phonemes ["Robust", "F", "a", "F2"]
phonemes ["Robust", "F", "u_corner", "F1"] = phonemes ["Robust", "F", "u", "F1"]/(2^(1/12))
phonemes ["Robust", "F", "u_corner", "F2"] = phonemes ["Robust", "F", "u", "F2"]/(2^(1/12))
# @_center is not fixed but derived from current corners
phonemes ["Robust", "F", "@_center", "F1"] =(phonemes ["Robust", "F", "i_corner", "F1"]*phonemes ["Robust", "F", "u_corner", "F1"]*phonemes ["Robust", "F", "a_corner", "F1"])^(1/3)
phonemes ["Robust", "F", "@_center", "F2"] = (phonemes ["Robust", "F", "i_corner", "F2"]*phonemes ["Robust", "F", "u_corner", "F2"]*phonemes ["Robust", "F", "a_corner", "F2"])^(1/3)

#####################################

# Timestep in seconds
timeStep = 0.005

# Size of window in seconds to smooth Unvoiced-Voiced formants
introWindow = 0.05

# Apply to all files

inputFile$ = ""
gender$ = "F"

separator$ = ";"

# Default values
i_F2fraction = 75
u_F2fraction = 75
a_F1fraction = 110

smootheningTime = 0.250


###############################################
#
# Start program: Interactive
#
###############################################

title$ = "untitled"
gender = 1
formant_algorithm = 1
source_signal = 1

# Run master loop
.continue = 1
while .continue = 1

	.recording = 0
	label START
	beginPause: "Select a recording"
		comment: "Open a sound file or a CSV file table for non-interactive use"
		comment: "Name of the output"
		sentence: "Title", title$
		optionMenu: "Gender", gender
			option: "Female"
			option: "Male"
		boolean: "Log", writeLog
		comment: "Select the format tracking algorithm to use"
		optionMenu: "Formant Algorithm", formant_algorithm
			option: "Robust"
			option: "Burg"
			option: "FormantPath"
		comment: "Size of the thee corners of the vowel space (% of citation space)"
		real: "i schwa F2 fraction (%)", i_F2fraction	
		real: "u schwa F2 fraction (%)", u_F2fraction
		real: "a i F1 fraction (%)", a_F1fraction
		real: "Smoothing Time (sec)", smootheningTime
		comment: "Select the source signal to use for re-synthesis"
		optionMenu: "Source Signal", source_signal
			option: "Pulse Train"
			option: "LPCerror"
			option: "Phonation"

	.clicked = endPause: "Help", "Open", 2
	
	# Clear	
	if .clicked = 1
		if fileReadable("VowelBender.man") 
			Read from file: "VowelBender.man"
		elsif fileReadable("ManPages/VowelBender.man")
			Read from file: "ManPages/VowelBender.man"
		else
			beginPause: "See manual"
			comment: "https://robvanson.github.io/VowelBender"
			helpClicked = endPause: "Continue", 1
		endif
		goto START
	endif

	gender$ = {"F", "M", "A"}[gender]
	writeLog = log
	targetFormantAlgorithm$ = {"Robust", "Burg", "FormantPath"}[ formant_algorithm]
	i_F2fraction = i_schwa_F2_fraction
	u_F2fraction = u_schwa_F2_fraction
    a_F1fraction = a_i_F1_fraction
	smootheningTime = smoothing_Time
	sourceSignal$ = {"Pulse Train", "LPCerror", "Phonation"}[source_Signal]
	
	# Read filename
	.fullFilename$ = chooseReadFile$: "Select a file"
	if .fullFilename$ = "" or not fileReadable(.fullFilename$) or not index_regex(.fullFilename$, "(?i\.(wav|mp3|aif[fc]|flac|nist|au|ogg|csv|tsv))")
		beginPause: ("No readable recording selected "+.fullFilename$)
		.clicked = endPause: "Continue", 1
		goto START
	else
		inputFile$ = .fullFilename$
	endif

	####################################
	# 
	# Do the work
	# 
	####################################

	fileInputTable = -1
	if index_regex(inputFile$, "\.(?icsv)$")
		if separator$ = ";"
			fileInputTable = Read Table from semicolon-separated file: inputFile$
		elsif separator$ = tab$ or separator$ = "tab"
			fileInputTable = Read Table from tab-separated file: inputFile$		
		else
			fileInputTable = Read Table from comma-separated file: inputFile$
		endif
	elsif index_regex(inputFile$, "\.(?itsv)$")
			fileInputTable = Read Table from tab-separated file: inputFile$
	else
		# Create file table
		fileInputTable = Create Table with column names: "table", 1, { "Filename", "Gender", "i-F2fraction", "u-F2fraction", "a-F1fraction", "Tsmooth", "Source", "Title", "Sourcedir", "Targetdir", "Formant", "Log" }
		sourceDir$ = replace_regex$(inputFile$, "[^/\\\\]+$", "", 0)
		inputFile$ =  replace_regex$(inputFile$, sourceDir$, "", 0)
		Set string value: 1, "Filename", inputFile$
		Set string value: 1, "Gender", gender$
		Set numeric value: 1, "i-F2fraction", i_F2fraction
		Set numeric value: 1, "u-F2fraction", u_F2fraction
		Set numeric value: 1, "a-F1fraction", a_F1fraction
		Set numeric value: 1, "Tsmooth", smootheningTime
		Set string value: 1, "Source", sourceSignal$
		Set string value: 1, "Sourcedir", sourceDir$
		Set string value: 1, "Targetdir", targetDir$	
		Set string value: 1, "Formant", targetFormantAlgorithm$	
		Set string value: 1, "Log", vowelBenderLogFile$	
	endif

	if fileInputTable <= 0
		exit: "No input"
	else
		cols$# = { "Filename", "Gender", "i-F2fraction", "u-F2fraction", "a-F1fraction", "Tsmooth", "Source", "Title", "Sourcedir", "Targetdir", "Formant", "Log" }
		numCols = size(cols$#)
		for .c to numCols
			selectObject: fileInputTable
			colName$ = cols$#[.c]
			colIndex = Get column index: colName$
			if colIndex <= 0
				Append column: colName$
				if index_regex(colName$, "(fraction|smooth)")
					Formula: colName$, "0"
				else
					Formula: colName$, "tab$"
				endif
			endif
		endfor
	endif

	numFiles = Get number of rows

	for .f to numFiles
		selectObject: fileInputTable
		
		sourceDir$ = Get value: .f, "Sourcedir"
		targetDir$ = Get value: .f, "Targetdir"
		outFileName$ = Get value: .f, "Title"
		if not index_regex(outFileName$, "\S")
			outFileName$ = title$
		endif
		.currentVowelBenderLogFile$ = Get value: .f, "Log"
		if not index_regex(.currentVowelBenderLogFile$, "\S")
			.currentVowelBenderLogFile$ = ""
		endif
		
		.currentFormantAlgorithm$ = Get value: .f, "Formant"
		if not index_regex(.currentFormantAlgorithm$, "\S")
			.currentFormantAlgorithm$ = targetFormantAlgorithm$
		endif
		
		if writeLog and .currentVowelBenderLogFile$ <> ""
			if not fileReadable (.currentVowelBenderLogFile$)
				writeFileLine: .currentVowelBenderLogFile$, "Title;Speaker;File;Language;Plotfile;date;i-fraction;u-fraction;a-fraction;T-smooth;Source;Formant;Log"
			endif
		endif

		inputFilename$ = Get value: .f, "Filename"
		gender$ = Get value: .f, "Gender"
		sourceSignal$ = Get value: .f, "Source"
		if not index_regex(sourceSignal$, "\S")
			sourceSignal$ = defaultSourceSignal$
		endif

		filename$ = replace_regex$(inputFilename$, "\.[^\.]+$", "", 0)
		
		# Note: . (dot) fractions are not percentages anymore
		.i_F2fraction = Get value: .f, "i-F2fraction"
		.i_F2fraction = .i_F2fraction / 100
		.u_F2fraction = Get value: .f, "u-F2fraction"
		.u_F2fraction = .u_F2fraction / 100
		.a_F1fraction = Get value: .f, "a-F1fraction"
		.a_F1fraction = .a_F1fraction / 100

		.smootheningTime = Get value: .f, "Tsmooth"

		# Input data
		sampleFreq = 11000
		preEmphasisFreq = 80
		if gender$ = "M"
			sampleFreq = 10000
			preEmphasisFreq = 50
		endif
		
		i_low = phonemes [.currentFormantAlgorithm$, gender$, "i", "F1"]
		i_high = 0
		if .i_F2fraction > 0
			i_high = semitonesToHertz (.i_F2fraction * (hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "i", "F2"]) - hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"]) ) + hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"]) )
		endif
		u_low = 0
		 if  .u_F2fraction > 0
			u_low  =  semitonesToHertz (.u_F2fraction * (hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "u", "F2"]) - hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"]) ) + hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"] ) )
		endif
		a_max = 0
		if .a_F1fraction > 0
			a_max  =  semitonesToHertz (.a_F1fraction * (hertzToSemitones (phonemes [.currentFormantAlgorithm$, gender$, "a", "F1"] )  - hertzToSemitones (i_low) ) + hertzToSemitones ( i_low ) ) 
		endif

		if i_high <= 0
			i_high = 100000
		endif
		if u_low <= 0
			u_low = 0
		endif
		if a_max <= 0
			a_max = 0
		endif

		openShift = 0
		openFactor = 1
		if a_max > 0
			openShift = a_max - phonemes [.currentFormantAlgorithm$, gender$, "A", "F1"]
			openFactor = (a_max - i_low) / (phonemes [.currentFormantAlgorithm$, gender$, "A", "F1"] - i_low)
		endif
		
		#Start
		recording = Read from file: sourceDir$ + inputFilename$
		Rename: "Recording"

		selectObject: recording
		recordingMono = Convert to mono
		Rename: "Mono"
		origSampleFreq = Get sampling frequency
		origIntensity = Get intensity (dB)

		pointProcess = noprogress To PointProcess (periodic, cc): 75, 600
		selectObject: pointProcess
		Rename: "VoicingPP"
		#vowelGrid = To TextGrid (vuv): 0.02, 0.01	
		#Rename: "VowelGrid"
		
		selectObject: recordingMono
		original = Resample: sampleFreq, 50
		Rename: "Resampled"
		# nowarn Save as WAV file: targetDir$ + "Resampled_" + string$(sampleFreq) + "_" + filename$ + ".wav"

		selectObject: recording
		Remove

		# Calculate formants
		selectObject: original
		if .currentFormantAlgorithm$ = "Robust"
			formants = noprogress To Formant (robust): timeStep, 5, sampleFreq/2, 0.025, preEmphasisFreq, 1.5, 5, 1e-06
			selectObject: original
			formantsBandwidth = noprogress To Formant (burg): timeStep, 5, sampleFreq/2, 0.025, preEmphasisFreq
		elsif .currentFormantAlgorithm$ = "FormantPath"
			formants = noprogress To FormantPath: timeStep, 5, sampleFreq/2, 0.025, preEmphasisFreq, "Burg", 0.05, 4, 1e-06, 1e-06, 1.5, 5, 1e-06, "no"
			selectObject: original
			formantsBandwidth = noprogress To Formant (burg): timeStep, 5, sampleFreq/2, 0.025, preEmphasisFreq
		else
			formants = noprogress To Formant (burg): timeStep, 5, sampleFreq/2, 0.025, preEmphasisFreq
			formantsBandwidth = Copy: "FormantsBandwith"
		endif
		selectObject: formants
		Rename: "OriginalFormants"
		
		call segment_syllables -25 4 0.3 1 original
		.syllableKernels = segment_syllables.textgridid
		@select_vowel_target: gender$, original, formants, formantsBandwidth, .syllableKernels
		.vowelTier = select_vowel_target.vowelTier
		.targetTier = select_vowel_target.targetTier
		selectObject: .syllableKernels
		vowelGrid = Extract one tier: .vowelTier
		.numIntervals = Get number of intervals: 1
		for .int to .numIntervals
			selectObject: vowelGrid
			.label$ = Get label of interval: 1, .int
			if .label$ <> "Vowel"
				Set interval text: 1, .int, "U"
			endif
		endfor
		selectObject: formantsBandwidth, .syllableKernels
		Remove
		
		# Manipulate formants
		if sourceSignal$ = "Phonation"	
			# Create phonation sound
			selectObject: pointProcess
			newSpeechSource = To Sound (phonation): origSampleFreq, 1, 0.05, 0.7, 0.03, 3, 4
		elsif sourceSignal$ = "Pulse Train"
			# Create pulse train sound
			selectObject: pointProcess
			newSpeechSource = To Sound (pulse train): origSampleFreq, 1, 0.05, 2000
		else
			# Create LPC error signal
			#selectObject: recordingMono
			selectObject: original
			
			# Rule: p ≈ 2 * fs(kHz) + 2  → ~20–26 poles for 10–11 kHz
			lpcOrder = round ( 2 * (sampleFreq / 1000) + 2 )
			lpcOrder = 3 * lpcOrder

			# LPC with pre-emphasis (F: 80 Hz, M:50 Hz)  
			lpcFilter = To LPC (autocorrelation): lpcOrder, 0.025, timeStep, preEmphasisFreq

			# Compute LPC residual
			selectObject: original
			plusObject: lpcFilter
			lpcErrorOrig = Filter (inverse)
			Rename: "LPCerrorOrig"

			lpcErrorRaw = Resample: origSampleFreq, 50
			Rename: "LPCerrorRaw"
			
			selectObject: lpcErrorRaw
			# Check this!!!
			lpcErrorPreEmphasis = Filter (pre-emphasis): preEmphasisFreq
			newSpeechSource = Filter (pass Hann band): preEmphasisFreq, 4500, 100
			#newSpeechSource = Copy: "LPCerror"
			Rename: "Source"
			
			selectObject: lpcFilter, lpcErrorOrig, lpcErrorRaw
			plusObject: lpcErrorPreEmphasis
			Remove
		endif

		# Manipulate formant grids
		selectObject: formants
		
		formantGrid = Down to FormantGrid
		formantGridFormula1 = Copy: "formantGridFormula1"
		if .u_F2fraction > 100
			schwaF2 = phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"]
			Formula (frequencies): "if row = 2 then if self < schwaF2 then schwaF2 + (self - schwaF2) * .u_F2fraction else self fi else self fi"
		else
			Formula (frequencies): "if row = 2 then if self < u_low then u_low else self fi else self fi"
		endif
		formantGridFormula2 = Copy: "formantGridFormula2"
		if .i_F2fraction > 100
			schwaF2 = phonemes [.currentFormantAlgorithm$, gender$, "@", "F2"]
			Formula (frequencies): "if row = 2 then if self > schwaF2 then schwaF2 + (self - schwaF2) * .i_F2fraction else self fi else self fi"
		else
			Formula (frequencies): "if row = 2 then if self > i_high then i_high else self fi else self fi"
		endif
		formantGridFormula3 = Copy: "formantGridFormula3"
		#Formula (frequencies): "if row = 1 then i_low + openFactor * (self - i_low) else self fi"
		Formula (frequencies): "if row = 1 then self + openShift else self fi"
		formantGridFormula4 = Copy: "formantGridFormula4"
		
		selectObject: formants
		Remove

		# Create fomants from FormantGrid	for manipulation
		selectObject: formantGridFormula4
		formants5 = noprogress To Formant: timeStep, 0.1
		Rename: "Formants5"

		# Low-pass filter F2. Cut-off is 1/.smootheningTime
		if .smootheningTime > 0
			##################################
			# F2
			##################################
			selectObject: formants5
			matrixF2_5 = To Matrix: 2
			# Frequency to seconds
			Formula: "1/self"
			matrixF2sound = To Sound
			Rename: "MatrixF2sound"

			# Filter
			matrixF2_5_lowPass = Filter (pass Hann band): 0, 1/.smootheningTime, 1
			matrixF2_6 = Down to Matrix
			Formula: "1/self"
			selectObject: formants5
			
			# Replace F2 values with filtered F2
			selectObject: vowelGrid
			numIntervals = Get number of intervals: 1
			for .i to numIntervals
				selectObject: vowelGrid
				.vowelSegment$ = Get label of interval: 1, .i
				if .vowelSegment$ = "Vowel"
					.start = Get start time of interval: 1, .i
					.end = Get end time of interval: 1, .i
					selectObject: formants5
					.startFrame = Get frame number from time: .start
					.startFrame = ceiling(.startFrame)
					.endFrame = Get frame number from time: .end
					.endFrame = floor(.endFrame)

					selectObject: formantGridFormula4
					Remove formant points between: 2, .start, .end
					
					for .frame from .startFrame to .endFrame
						selectObject: matrixF2_6
						.filteredF2 = Get value in cell: 1, .frame
						
						selectObject: formants5
						.time = Get time from frame number: .frame
						
						selectObject: formantGridFormula4
						Add formant point: 2, .time, .filteredF2
						# Add formant point: 2, .time, 1500
					endfor
				endif
			endfor
			
			selectObject: matrixF2_5, matrixF2_6, matrixF2sound, matrixF2_5_lowPass
			Remove

		endif

		##################################
		#	
		#	vowel		
		# 
		##################################
		# Replace F2 values with smoothed F1/F2
		selectObject: vowelGrid
		numIntervals = Get number of intervals: 1
		for .i to numIntervals - 1
			selectObject: vowelGrid
			.vowelSegment$ = Get label of interval: 1, .i
			if .vowelSegment$ = "U"
				.start = Get start time of interval: 1, .i
				.end = Get end time of interval: 1, .i
				.currenIntroWindow = min(introWindow, .end - .start)

				# F1
				selectObject: formants5
				.formantStart = Get value at time: 1, .end - .currenIntroWindow, "hertz", "linear"
				.formantEnd = Get value at time: 1, .end + timeStep, "hertz", "linear"
				selectObject: formantGridFormula4
				Remove formant points between: 1, .end - .currenIntroWindow, .end
				.time = .end - .currenIntroWindow
				while .time <= .end
					@cosineInterpolation: .time, .formantStart, .formantEnd, .end - .currenIntroWindow, .end
					.formantValue = cosineInterpolation.value
					selectObject: formantGridFormula4
					Add formant point: 1, .time, .formantValue
					.time = .time + timeStep
				endwhile
				
				# F2
				selectObject: formants5
				.formantStart = Get value at time: 2, .end - .currenIntroWindow, "hertz", "linear"
				.formantEnd = Get value at time: 2, .end + timeStep, "hertz", "linear"
				selectObject: formantGridFormula4
				Remove formant points between: 2, .end - .currenIntroWindow, .end
				.time = .end - .currenIntroWindow
				while .time <= .end
					@cosineInterpolation: .time, .formantStart, .formantEnd, .end - .currenIntroWindow, .end
					.formantValue = cosineInterpolation.value
					selectObject: formantGridFormula4
					Add formant point: 2, .time, .formantValue
					.time = .time + timeStep
				endwhile
			endif
		endfor

		selectObject: formants5
		Remove

		# Resynthesize speech from original formants
		selectObject: formantGrid
		plusObject: newSpeechSource
		reconstructedSpeech = Filter
		Scale intensity: 70
		Rename: "ReconstructedSpeech"
		#	nowarn Save as WAV file: targetDir$ + "Reconstructed" + string$(sampleFreq) + "_" + filename$ + ".wav"
		
		# Resynthesize speech from altered formants
		selectObject: formantGridFormula1, newSpeechSource
		#reshapedSpeech1 = Filter

		selectObject: formantGridFormula2, newSpeechSource
		#reshapedSpeech2 = Filter

		selectObject: formantGridFormula3, newSpeechSource
		#reshapedSpeech3 = Filter

		selectObject: formantGridFormula4
		plusObject: newSpeechSource

		reshapedSpeech = Filter
		Rename: "ReshapedSpeech"
			
		# Combine original with reshaped speech
		selectObject: recordingMono
		originalHighPass = Filter (stop Hann band): 200, 3000, 100
		Rename: "OriginalHighPass"
		selectObject: recordingMono
		originalLowPass = Filter (pass Hann band): 200, 3000, 100
		Rename: "OriginalLowPass"
		originalLowPassInt = Get intensity (dB)
		
		selectObject: reshapedSpeech
		reshapedLowPass = Filter (pass Hann band): 200, 3000, 100
		Rename: "ReshapedLowPass"
		Scale intensity: originalLowPassInt
		
		# Recombine
		selectObject: originalHighPass, reshapedLowPass
		stereoHighLow = Combine to stereo
		Rename: "StereoHighLow"
		recombinedHighLow = Convert to mono
		Rename: "RecombinedHighLow"
		
		selectObject: stereoHighLow, originalHighPass, originalLowPass, reshapedLowPass
		Remove
		
		# Combine original unvoiced with reshaped voiced
		selectObject: recordingMono
		Scale intensity: 70
		selectObject: recombinedHighLow
		Scale intensity: 70
		
		selectObject: vowelGrid
		numIntervals = Get number of intervals: 1
		for .i to numIntervals
			selectObject: vowelGrid
			.vowelSegment$ = Get label of interval: 1, .i
			.start = Get start time of interval: 1, .i
			.end = Get end time of interval: 1, .i

			if .vowelSegment$ = "Vowel"
				selectObject: recordingMono
				Set part to zero: .start, .end, "at exactly these times"
			else
				selectObject: recombinedHighLow
				Set part to zero: .start, .end, "at exactly these times"
			endif
		endfor
		selectObject: recombinedHighLow, recordingMono
		stereoFinalSound = Combine to stereo
		Rename: "StereoFinalSound"
		finalSound = Convert to mono
		Rename: "FinalSound"
		
		if outFileName$ = "untitled" or not index_regex(outFileName$, "\S")
			outFileName$ = filename$ + "_" + "i-"+ fixed$(100*.i_F2fraction, 0) + "_" + "u-"+ fixed$(100*.u_F2fraction, 0) + "_" + "a-"+ fixed$(100*.a_F1fraction, 0) + "_Smooth-" + fixed$(.smootheningTime,3) + "_" + sourceSignal$
		endif
		
		selectObject: finalSound
		if not index_regex(targetDir$, "\S")
			label ASKFOROUTPUTFILENAME
			.outFilePath$ = chooseWriteFile$: "Save as WAV file", outFileName$ + ".wav"
			 
			if .outFilePath$ = ""
				# Ready or not?
				beginPause: "No valid filename, retry"
					comment: "Retry or Stop and discard current data"
				.clicked = endPause: "Retry", "Stop", 2, 2
				if (.clicked = 1)
					goto ASKFOROUTPUTFILENAME
				else
					goto CLEANUP
				endif
			endif
			
		else
			.outFilePath$ = targetDir$ + outFileName$ + ".wav"
		endif
		
		if .outFilePath$ <> ""
			nowarn Save as WAV file:  .outFilePath$
		endif
		
			
		if writeLog and .currentVowelBenderLogFile$ <> ""
			.vowelTriangleLog$ = replace_regex$(.currentVowelBenderLogFile$, "(?iLog)", "VowelTriangleLog", 0)
			.rowLine$ = outFileName$+";"
			... + gender$+";"
			... + targetDir$ + outFileName$ + ".wav"+";"
			... + "EN" + ";" 
			... + targetDir$ + outFileName$ + ".png" + ";"
			... + date$() + ";"
			... + fixed$(100*.i_F2fraction, 0) + ";"
			... + fixed$(100*.u_F2fraction, 0) + ";" 
			... + fixed$(100*.a_F1fraction, 0) + ";"
			... + fixed$(.smootheningTime,3) + ";"
			... + sourceSignal$ + ";"
			... + .currentFormantAlgorithm$ + ";"
			... + .vowelTriangleLog$
			.rowLine$ = replace$ (.rowLine$, "--undefined--", "NA", 0)

			appendFileLine: .currentVowelBenderLogFile$, .rowLine$
		endif

		#pauseScript: "Pause"
		
		# Clean up
		label CLEANUP
		selectObject: recordingMono, original, formantGrid, formantGridFormula1,formantGridFormula2
		plusObject: formantGridFormula3, formantGridFormula4
		plusObject: reconstructedSpeech, reshapedSpeech, newSpeechSource, recombinedHighLow
		plusObject: pointProcess, vowelGrid, stereoFinalSound, finalSound
		Remove

	endfor

	selectObject: fileInputTable
	Remove

	
	# Ready or not?
	pauseScript: "Continue with new data or stop the script"
	.continue = 1
	
	label NEXTROUND
	
endwhile

label ENDOFVOWELBENDER

# Function to do a cosine interpolation between two formant values
procedure cosineInterpolation: .t, .startValue, .endValue, .startTime, .endTime
	.value = .startValue + (.endValue - .startValue) * (1 - cos(pi * (.t - .startTime)/(.endTime - .startTime)))/2
endproc

# 
# Load VowelTriangleProcedures.praat 
include VowelTriangleProcedures.praat
