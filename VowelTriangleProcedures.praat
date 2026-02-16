#! praat
# 
# Procedures for VowelTriangle.praat
#
# We thank Xinyu Zhang for the Chinese translation (2019).
#
# Unless specified otherwise:
#
# Copyright: 2017-2025, R.J.J.H. van Son and the Netherlands Cancer Institute
# License: GNU GPL v3 or later
# email: r.j.j.h.vanson@gmail.com, r.v.son@nki.nl
# 
#     VowelTriangle.praat: Praat script to practice vowel pronunciation 
#     
#     Copyright (C) 2017  R.J.J.H. van Son and the Netherlands Cancer Institute
# 
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 2 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
# 

test$ = "GESLAAGD!"
#######################################################################
#
# Procedure definitions
#
#######################################################################
#


#####################################################################
# 
# Use a TextGrid to select the vowel segments
# 
procedure read_and_process_TextGrid .textGridname$ .tier .vowelString$
	.tmpTextGrid = Read from file: .textGridname$
	.numTiers = Get number of tiers
	.textGrid = -1
	if .tier <= 0 or .numTiers < .tier
		goto ENDOFREADANDPROCESSTEXTGRID
	endif
	
	if index_regex(.vowelString$, "\w") <= 0
		.vowelString$ = vowels$ [uiLanguage$]
	endif
	
	.textGrid = Extract one tier: .tier
	Set tier name: 1, "Vowel"
	.numIntervals = Get number of intervals: 1
	for .int to .numIntervals
		selectObject: .textGrid
		.label$ = Get label of interval: 1, .int
		# Remove extraneous text from labels
		.label$ = replace_regex$(.label$, "__.*$", "", 0)
		if not index(.vowelString$, " "+.label$+" ")
			.label$ = ""
		else
			.label$ = "Vowel"
		endif
		Set interval text: 1, .int, .label$
	endfor
	# Now, change the intervals to include only the central 2/3, from back to front
	for .int to .numIntervals
		selectObject: .textGrid
		.j = 1 + .numIntervals - .int
		.label$ = Get label of interval: 1, .j
		if .label$ = "Vowel"
			Set interval text: 1, .j, ""
			.start = Get start time of interval: 1, .j
			.end = Get end time of interval: 1, .j
			.s1 = .start + (.end - .start)/6
			.s2 = .start + 5*(.end - .start)/6
			Insert boundary: 1, .s1
			Insert boundary: 1, .s2
			Set interval text: 1, .j+1, "Vowel"
		endif
	endfor
	
	label ENDOFREADANDPROCESSTEXTGRID
	
	selectObject: .tmpTextGrid
	Remove
endproc

procedure read_and_select_audio .type .message1$ .message2$
	.sound = -1
	.textGrid = -1
	if .type
		Record mono Sound...
		beginPause: (uiMessage$ [uiLanguage$, "PauseRecord"])
			comment: uiMessage$ [uiLanguage$, "CommentList"]
		.clicked = endPause: (uiMessage$ [uiLanguage$, "Stop"]), (uiMessage$ [uiLanguage$, "Continue"]), 2, 1
		if .clicked = 1
			pauseScript: (uiMessage$ [uiLanguage$, "Stopped"])
			goto RETURN
		endif
		if numberOfSelected("Sound") <= 0
			pauseScript: (uiMessage$ [uiLanguage$, "ErrorSound"])
			goto RETURN
		endif
		.source = selected ("Sound")
		.filename$ = "Recorded speech"
	else
		.fullFilename$ = chooseReadFile$: .message1$
		if .fullFilename$ = "" or not fileReadable(.fullFilename$) or not index_regex(.fullFilename$, "(?i\.(wav|mp3|aif[fc]|flac|nist|au|ogg))")
			pauseScript: (uiMessage$ [uiLanguage$, "No readable recording selected "])+.fullFilename$
			goto RETURN
		endif
		
		if index_regex (.fullFilename$, "(?i\.ogg)")
			.source = Read from file: .fullFilename$
			.filename$ = selected$("Sound")
		else
			.source = Open long sound file: .fullFilename$
			.filename$ = selected$("LongSound")
		endif
		.fullName$ = selected$()
		.fileType$ = extractWord$ (.fullName$, "")
		if .fileType$ <> "Sound" and .fileType$ <> "LongSound"
			pauseScript:  (uiMessage$ [uiLanguage$, "ErrorSound"])+.filename$
			goto RETURN
		endif
		
		if segmentTier > 0
			.textGridname$ = replace_regex$(.fullFilename$, "(?i\.(wav|mp3|aif[fc]|flac|nist|au|ogg))$", ".TextGrid", 0)
			# Ask for a TextGrid file if a tier number has been given
			if ! fileReadable(.textGridname$)
				writeInfoLine: uiMessage$ [uiLanguage$, "Open3"]
				Erase all
				Select outer viewport: 0, 8, 0, 8
				Select inner viewport: 0.5, 7.5, 0.5, 4.5
				Axes: 0, 1, 0, 1
				Blue
				Text special: 0, "left", 0.65, "half", "Helvetica", 16, "0", "##"+uiMessage$ [uiLanguage$, "Open3"]+"#"
				Black
				.tmp$ = chooseReadFile$: uiMessage$ [uiLanguage$, "Open3"]
				if .tmp$ <> ""
					.textGridname$ = .tmp$
				endif
			endif
			if fileReadable(.textGridname$)
				@read_and_process_TextGrid: .textGridname$, segmentTier, vowelString$
				.textGrid = read_and_process_TextGrid.textGrid
				if index_regex(vowelString$, "\w") <= 0
					vowelString$ = read_and_process_TextGrid.vowelString$
				endif
			endif
		endif
	endif
	
	selectObject: .source
	.fullName$ = selected$()
	.duration = Get total duration
	if startsWith(.fullName$, "Sound") 
		View & Edit
	else
		View
	endif
	editor: .source
	endeditor
	beginPause: .message2$
		comment: (uiMessage$ [uiLanguage$, "SelectSound1"])
		comment: (uiMessage$ [uiLanguage$, "SelectSound2"])
		comment: (uiMessage$ [uiLanguage$, "SelectSound3"])
	.clicked = endPause: (uiMessage$ [uiLanguage$, "Stop"]), (uiMessage$ [uiLanguage$, "Continue"]), 2, 1
	if .clicked = 1
		selectObject: .source
		Remove
		pauseScript: (uiMessage$ [uiLanguage$, "Stopped"])
		goto RETURN
	endif
	
	.start = -1
	.end = -1
	editor: .source
		.start = Get start of selection
		.end = Get end of selection
		if .start >= .end
			Select: 0, .duration
		endif
		Extract selected sound (time from 0)
	endeditor
	.tmp = selected ()
	if .tmp <= 0
		selectObject: .source
		.duration = Get total duration
		.tmp = Extract part: 0, .duration, "yes"
	endif
	# Handle very low recording levels
	selectObject: .tmp
	Scale intensity: 70
	
	# Get selection of TextGrid
	if .textGrid > 0 and .start >= 0 and .end > .start
		selectObject: .textGrid
		.tmp1 = Extract part: .start, .end, "no"
		selectObject: .textGrid
		Remove
		.textGrid = .tmp1
		.tmp1 = -1
	endif

	# Recordings can be in Stereo, change to mono
	selectObject: .tmp
	.numChannels = Get number of channels
	if .numChannels > 1
		.maxInt = -10000
		.bestChannel = 1
		for .c to .numChannels
			selectObject: .tmp
			.tmpChannel = Extract one channel: .c
			.currentInt = Get intensity (dB)
			if .currentInt > .maxInt
				.maxInt = .currentInt
				.bestChannel = .c
			endif
			selectObject: .tmpChannel
			Remove
		endfor
		selectObject: .tmp
		.sound = Extract one channel: .bestChannel
		Rename: .filename$
	else
		selectObject: .tmp
		.sound = Copy: .filename$
	endif

	selectObject: .tmp, .source
	Remove

	selectObject: .sound
	Rename: .filename$
	
	label RETURN

endproc

# Set up Canvas
procedure set_up_Canvas
	Select outer viewport: 0, 8, 0, 8
	Select inner viewport: 0.75, 7.25, 0.75, 7.25
	Axes: 0, 1, 0, 1
	Solid line
	Black
	Line width: 1.0
endproc

# Plot the vowels in a sound
# .plot: Actually plot inside picture window or just calculate paramters
procedure plot_vowels .plot .sp$ .sound .vowelTextGrid
	.startT = 0
	.dot_Radius = default_Dot_Radius

	#call syllable_nuclei -25 4 0.3 1 .sound
	#.syllableKernels = syllable_nuclei.textgridid
	if .vowelTextGrid <= 0
		call segment_syllables -25 4 0.3 1 .sound
		.syllableKernels = segment_syllables.textgridid
	else
		selectObject: .vowelTextGrid
		.syllableKernels = Copy: "Vowels"
		Insert point tier: 2, "VowelTarget"
		.numVowels = Get number of intervals: 1
		for .int to .numVowels
			.label$ = Get label of interval: 1, .int
			if .label$ <> ""
				.start = Get start time of interval: 1, .int
				.end = Get end time of interval: 1, .int
				.target = (.start + .end)/2
				Insert point: 2, .target, "P"
			endif
		endfor
	endif
	
	# Calculate the formants
	selectObject: .sound
	.duration = Get total duration
	.soundname$ = selected$("Sound")
	if .sp$ = "M"
		.maxFormant = 5000
	else
		.maxFormant = 5500
	endif
	
	# Calculate Slope
	selectObject: .sound
	# Use only voiced intervals
	.pp = noprogress To PointProcess (periodic, cc): 50, 600
	.vuv = To TextGrid (vuv): 0.02, 0.01
	selectObject: .sound, .vuv
	Extract intervals where: 1, "no", "is equal to", "V"
	.numIntervals = numberOfSelected ()
	.sounds# = selected#("Sound")
	.voicedIntervals = Concatenate
	# Determine Ltas and slope
	.ltas = To Ltas: 100
	.slope = Get slope: 0, 1000, 1000, 10000, "dB"
	# Remove all intermediate objects
	selectObject: .ltas, .vuv
	for i to .numIntervals
		plusObject: .sounds#[i]
		Remove
	endfor
	plusObject: .voicedIntervals, .pp
	Remove

	# Targets
	# Calculate formants
	selectObject: .sound
	if targetFormantAlgorithm$ = "Burg"
		.formants = noprogress To Formant (burg): 0, 5, .maxFormant, 0.025, 50
		.formantsBandwidth = Copy: "Plot"
	elsif targetFormantAlgorithm$ = "Robust"
		.formants = noprogress To Formant (robust): 0.01, 5, .maxFormant, 0.025, 50, 1.5, 5, 1e-06
		.formantsBandwidth = Copy: "Bandwidth"
	elsif targetFormantAlgorithm$ = "KeepAll"
		.formants = noprogress To Formant (keep all): 0.01, 5, .maxFormant, 0.025, 50
		.formantsBandwidth = Copy: "Bandwidth"
	else
		selectObject: .sound
		.downSampled = Resample: 2*.maxFormant, 50
		.formants = noprogress To Formant (sl): 0, 5, .maxFormant, 0.025, 50
		selectObject: .downSampled
		Remove
		selectObject: .sound
		.formantsBandwidth = noprogress To Formant (burg): 0, 5, .maxFormant, 0.025, 50
	endif
	
	if targetFormantAlgorithm$ = plotFormantAlgorithm$
		.formantsPlot = .formants
	else
		selectObject: .sound
		if plotFormantAlgorithm$ = "Burg"
			.formantsPlot = noprogress To Formant (burg): 0, 5, .maxFormant, 0.025, 50
		elsif plotFormantAlgorithm$ = "Robust"
			.formantsPlot = noprogress To Formant (robust): 0.01, 5, .maxFormant, 0.025, 50, 1.5, 5, 1e-06
		elsif plotFormantAlgorithm$ = "KeepAll"
			formantsPlot = noprogress To Formant (keep all): 0, 5, .maxFormant, 0.025, 50
		else
			.downSampled = Resample: 2*.maxFormant, 50
			.formantsPlot = noprogress To Formant (sl): 0, 5, .maxFormant, 0.025, 50
			selectObject: .downSampled
			Remove
		endif
	endif
	
	# Plot
	@select_vowel_target: .sp$, .sound, .formants, .formantsBandwidth, .syllableKernels
	.vowelTier = select_vowel_target.vowelTier
	.targetTier = select_vowel_target.targetTier
	selectObject: .syllableKernels
	.numTargets = Get number of points: .targetTier
	if .numTargets > dot_Radius_Cutoff
		.dot_Radius = default_Dot_Radius / sqrt(.numTargets/dot_Radius_Cutoff)
	endif

	# Get Vocal Track Length
	.vtlScaling = 1
	.vocalTractLength = -1
	if vtl_normalization or not .plot
		@estimate_Vocal_Tract_Length: .formantsPlot, .syllableKernels, .targetTier
		.vocalTractLength = estimate_Vocal_Tract_Length.vtl
		if vtl_normalization
			.sp$ = "F"
			if estimate_Vocal_Tract_Length.phi < averagePhi_VTL [plotFormantAlgorithm$, "A"]
				.sp$ = "M"
			endif
			# Watch out .sp$ must be set BEFORE the scaling
			.vtlScaling = averagePhi_VTL [plotFormantAlgorithm$, .sp$] / estimate_Vocal_Tract_Length.phi
		endif
	endif
	
	# Draw new vowel triangle
	if .plot
		@plot_vowel_triangle: .sp$
	endif

	# Set new @_center
	phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F1"] = (phonemes [plotFormantAlgorithm$, .sp$, "a", "F1"] * phonemes [plotFormantAlgorithm$, .sp$, "i", "F1"] * phonemes [plotFormantAlgorithm$, .sp$, "u", "F1"]) ** (1/3) 
	phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F2"] = (phonemes [plotFormantAlgorithm$, .sp$, "a", "F2"] * phonemes [plotFormantAlgorithm$, .sp$, "i", "F2"] * phonemes [plotFormantAlgorithm$, .sp$, "u", "F2"]) ** (1/3) 
	
	.f1_c = phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F1"]
	.f2_c = phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F2"]
	
	# Plot center
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_c, .f2_c
	.st_c1 = vowel2point.x
	.st_c2 = vowel2point.y
	
	# Near /@/
	.f1_c = phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F1"]
	.f2_c = phonemes [plotFormantAlgorithm$, .sp$, "@_center", "F2"]
	@get_closest_vowels: 0, .sp$, .formants, .formantsPlot, .syllableKernels, .f1_c, .f2_c, .vtlScaling
	.numVowelIntervals = get_closest_vowels.vowelNum
	# Actually plot the vowels
	if .plot
		for .i to get_closest_vowels.vowelNum
			.f1 = get_closest_vowels.f1_list [.i]
			.f2 = get_closest_vowels.f2_list [.i]
			@vowel2point: .vtlScaling, plotFormantAlgorithm$, .sp$, .f1, .f2
			.x = vowel2point.x
			.y = vowel2point.y
			Paint circle: color$["@"], .x, .y, .dot_Radius
		endfor
	endif
	
	# Near /i/
	.f1_i = phonemes [plotFormantAlgorithm$, .sp$, "i", "F1"]
	.f2_i = phonemes [plotFormantAlgorithm$, .sp$, "i", "F2"]
	@get_closest_vowels: 0, .sp$, .formants, .formantsPlot, .syllableKernels, .f1_i, .f2_i, .vtlScaling
	.meanDistToCenter ["i"] = get_closest_vowels.meanDistance
	.stdevDistToCenter ["i"] = get_closest_vowels.stdevDistance
	.num_i_Intervals = get_closest_vowels.vowelNum
	# Actually plot the vowels
	if .plot
		for .i to get_closest_vowels.vowelNum
			.f1 = get_closest_vowels.f1_list [.i]
			.f2 = get_closest_vowels.f2_list [.i]
			@vowel2point: .vtlScaling, plotFormantAlgorithm$, .sp$, .f1, .f2
			.x = vowel2point.x
			.y = vowel2point.y
			Paint circle: color$["i"], .x, .y, .dot_Radius
		endfor
	endif
	
	# Near /u/
	.f1_u = phonemes [plotFormantAlgorithm$, .sp$, "u", "F1"]
	.f2_u = phonemes [plotFormantAlgorithm$, .sp$, "u", "F2"]
	@get_closest_vowels:  0, .sp$, .formants, .formantsPlot, .syllableKernels, .f1_u, .f2_u, .vtlScaling
	.meanDistToCenter ["u"] = get_closest_vowels.meanDistance
	.stdevDistToCenter ["u"] = get_closest_vowels.stdevDistance
	.num_u_Intervals = get_closest_vowels.vowelNum
	# Actually plot the vowels
	if .plot
		for .i to get_closest_vowels.vowelNum
			.f1 = get_closest_vowels.f1_list [.i]
			.f2 = get_closest_vowels.f2_list [.i]
			@vowel2point: .vtlScaling, plotFormantAlgorithm$, .sp$, .f1, .f2
			.x = vowel2point.x
			.y = vowel2point.y
			Paint circle: color$["u"], .x, .y, .dot_Radius
		endfor
	endif
	
	# Near /a/
	.f1_a = phonemes [plotFormantAlgorithm$, .sp$, "a", "F1"]
	.f2_a = phonemes [plotFormantAlgorithm$, .sp$, "a", "F2"]
	@get_closest_vowels:  0, .sp$, .formants, .formantsPlot, .syllableKernels, .f1_a, .f2_a, .vtlScaling
	.meanDistToCenter ["a"] = get_closest_vowels.meanDistance
	.stdevDistToCenter ["a"] = get_closest_vowels.stdevDistance
	.num_a_Intervals = get_closest_vowels.vowelNum
	# Actually plot the vowels
	if .plot
		for .i to get_closest_vowels.vowelNum
			.f1 = get_closest_vowels.f1_list [.i]
			.f2 = get_closest_vowels.f2_list [.i]
			@vowel2point: .vtlScaling, plotFormantAlgorithm$, .sp$, .f1, .f2
			.x = vowel2point.x
			.y = vowel2point.y
			Paint circle: color$["a"], .x, .y, .dot_Radius
		endfor
	endif
	
	# Print center and corner markers
	# Center
	if .plot
		.x = .st_c1
		.y = .st_c2
		Black
		Solid line
		Draw line: .x-0.007, .y+0.007, .x+0.007, .y-0.007
		Draw line: .x-0.007, .y-0.007, .x+0.007, .y+0.007
		# u
		@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_u, .f2_u	
		.x = vowel2point.x
		.y = vowel2point.y
		Black
		Solid line
		Draw line: .x-0.007, .y+0.007, .x+0.007, .y-0.007
		Draw line: .x-0.007, .y-0.007, .x+0.007, .y+0.007
		# i
		@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_i, .f2_i	
		.x = vowel2point.x
		.y = vowel2point.y
		Black
		Solid line
		Draw line: .x-0.007, .y+0.007, .x+0.007, .y-0.007
		Draw line: .x-0.007, .y-0.007, .x+0.007, .y+0.007
		# a
		@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_a, .f2_a	
		.x = vowel2point.x
		.y = vowel2point.y
		Black
		Solid line
		Draw line: .x-0.007, .y+0.007, .x+0.007, .y-0.007
		Draw line: .x-0.007, .y-0.007, .x+0.007, .y+0.007
	endif
	
	# Draw new triangle
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_i, .f2_i
	.st_i1 = vowel2point.x
	.st_i2 = vowel2point.y
	.ic_dist = sqrt((.st_c1 - .st_i1)^2 + (.st_c2 - .st_i2)^2)
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_u, .f2_u
	.st_u1 = vowel2point.x
	.st_u2 = vowel2point.y
	.uc_dist = sqrt((.st_c1 - .st_u1)^2 + (.st_c2 - .st_u2)^2)
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1_a, .f2_a
	.st_a1 = vowel2point.x
	.st_a2 = vowel2point.y
	.ac_dist = sqrt((.st_c1 - .st_a1)^2 + (.st_c2 - .st_a2)^2)
	
	# Vowel tirangle surface area (Heron's formula)
	.auDist = sqrt((.st_a1 - .st_u1)^2 + (.st_a2 - .st_u2)^2)
	.aiDist = sqrt((.st_a1 - .st_i1)^2 + (.st_a2 - .st_i2)^2)
	.uiDist = sqrt((.st_u1 - .st_i1)^2 + (.st_u2 - .st_i2)^2)
	.p = (.auDist + .aiDist + .uiDist)/2
	.areaVT = sqrt(.p * (.p - .auDist) * (.p - .aiDist) * (.p - .uiDist))

	# 1 stdev
	# c - i
	.relDist = (.meanDistToCenter ["i"] + 1 * .stdevDistToCenter ["i"]) / .ic_dist
	.x ["i"] = .st_c1 + .relDist * (.st_i1 - .st_c1)
	.y ["i"] = .st_c2 + .relDist * (.st_i2 - .st_c2)
	# c - u
	.relDist = (.meanDistToCenter ["u"] + 1 * .stdevDistToCenter ["u"]) / .uc_dist
	.x ["u"] = .st_c1 + .relDist * (.st_u1 - .st_c1)
	.y ["u"] = .st_c2 + .relDist * (.st_u2 - .st_c2)
	# c - a
	.relDist = (.meanDistToCenter ["a"] + 1 * .stdevDistToCenter ["a"]) / .ac_dist
	.x ["a"] = .st_c1 + .relDist * (.st_a1 - .st_c1)
	.y ["a"] = .st_c2 + .relDist * (.st_a2 - .st_c2)
	
	if .plot
		Black
		Dotted line
		Draw line: .x ["a"], .y ["a"], .x ["i"], .y ["i"]
		Draw line: .x ["i"], .y ["i"], .x ["u"], .y ["u"]
		Draw line: .x ["u"], .y ["u"], .x ["a"], .y ["a"]
	endif

	# Vowel tirangle surface area (Heron's formula)
	.auDist = sqrt((.x ["a"] - .x ["u"])^2 + (.y ["a"] - .y ["u"])^2)
	.aiDist = sqrt((.x ["a"] - .x ["i"])^2 + (.y ["a"] - .y ["i"])^2)
	.uiDist = sqrt((.x ["u"] - .x ["i"])^2 + (.y ["u"] - .y ["i"])^2)
	.p = (.auDist + .aiDist + .uiDist)/2
	.areaSD1 = sqrt(.p * (.p - .auDist) * (.p - .aiDist) * (.p - .uiDist))
	.area1perc = 100*(.areaSD1 / .areaVT)

	# 2 stdev
	# c - i
	.relDist_i = (.meanDistToCenter ["i"] + 2 * .stdevDistToCenter ["i"]) / .ic_dist
	.x ["i"] = .st_c1 + .relDist_i * (.st_i1 - .st_c1)
	.y ["i"] = .st_c2 + .relDist_i * (.st_i2 - .st_c2)
	# c - u
	.relDist_u = (.meanDistToCenter ["u"] + 2 * .stdevDistToCenter ["u"]) / .uc_dist
	.x ["u"] = .st_c1 + .relDist_u * (.st_u1 - .st_c1)
	.y ["u"] = .st_c2 + .relDist_u * (.st_u2 - .st_c2)
	# c - a
	.relDist_a = (.meanDistToCenter ["a"] + 2 * .stdevDistToCenter ["a"]) / .ac_dist
	.x ["a"] = .st_c1 + .relDist_a * (.st_a1 - .st_c1)
	.y ["a"] = .st_c2 + .relDist_a * (.st_a2 - .st_c2)
	# Convert to percentages
	.relDist_i *= 100
	.relDist_u *= 100
	.relDist_a *= 100
	
	if .plot
		Black
		Solid line
		Draw line: .x ["a"], .y ["a"], .x ["i"], .y ["i"]
		Draw line: .x ["i"], .y ["i"], .x ["u"], .y ["u"]
		Draw line: .x ["u"], .y ["u"], .x ["a"], .y ["a"]
	endif

	# Vowel tirangle surface area (Heron's formula)
	.auDist = sqrt((.x ["a"] - .x ["u"])^2 + (.y ["a"] - .y ["u"])^2)
	.aiDist = sqrt((.x ["a"] - .x ["i"])^2 + (.y ["a"] - .y ["i"])^2)
	.uiDist = sqrt((.x ["u"] - .x ["i"])^2 + (.y ["u"] - .y ["i"])^2)
	.p = (.auDist + .aiDist + .uiDist)/2
	.areaSD2 = sqrt(.p * (.p - .auDist) * (.p - .aiDist) * (.p - .uiDist))
	.area2perc = 100*(.areaSD2 / .areaVT)

	# Print areas as percentage
	if .plot
		.dY = 0
		if vtl_normalization
			.dY = 0.05
		endif
		.shift = Text width (world coordinates): " ('plotFormantAlgorithm$')"
		Text special: 0.95+.shift, "right", 0.07 + .dY, "bottom", "Helvetica", 16, "0", uiMessage$ [uiLanguage$, "AreaTitle"]+" ('plotFormantAlgorithm$')"
		Text special: 0.8, "right", 0.02 + .dY, "bottom", "Helvetica", 14, "0", uiMessage$ [uiLanguage$, "Area1"]
		Text special: 0.8, "left", 0.02 + .dY, "bottom", "Helvetica", 14, "0", ": '.area1perc:0'\% "
		Text special: 0.8, "right", -0.03 + .dY, "bottom", "Helvetica", 14, "0", uiMessage$ [uiLanguage$, "Area2"]
		Text special: 0.8, "left", -0.03 + .dY, "bottom", "Helvetica", 14, "0", ": '.area2perc:0'\% "
		Text special: 0.8, "right", -0.08 + .dY, "bottom", "Helvetica", 14, "0", uiMessage$ [uiLanguage$, "AreaN"]
		Text special: 0.8, "left", -0.08 + .dY, "bottom", "Helvetica", 14, "0", ": '.numVowelIntervals' ('.duration:0' s, '.slope:1' dB)"
		if vtl_normalization
			Text special: 0.8, "right", -0.08, "bottom", "Helvetica", 14, "0", uiMessage$ [uiLanguage$, "VTL"]
			Text special: 0.8, "left", -0.08, "bottom", "Helvetica", 14, "0", ": '.vocalTractLength:1' cm"
		endif

		# Relative distance to corners
		Text special: -0.1, "left", 0.07 + .dY, "bottom", "Helvetica", 16, "0", uiMessage$ [uiLanguage$, "DistanceTitle"]
		Text special: 0.0, "right", 0.02 + .dY, "bottom", "Helvetica", 14, "0", "/i/:"
		Text special: 0.16, "right", 0.02 + .dY, "bottom", "Helvetica", 14, "0", " '.relDist_i:0'\%  ('.num_i_Intervals')"
		Text special: 0.0, "right", -0.03 + .dY, "bottom", "Helvetica", 14, "0", "/u/:"
		Text special: 0.16, "right", -0.03 + .dY, "bottom", "Helvetica", 14, "0", " '.relDist_u:0'\%  ('.num_u_Intervals')"
		Text special: 0.0, "right", -0.08 + .dY, "bottom", "Helvetica", 14, "0", "/a/:"
		Text special: 0.16, "right", -0.08 + .dY, "bottom", "Helvetica", 14, "0", " '.relDist_a:0'\%  ('.num_a_Intervals')"
	endif

	selectObject: .formants, .formantsBandwidth, .syllableKernels
	Remove
endproc

procedure print_output_line .title$, .sp$, .numVowelIntervals, .area2perc, .area1perc, .relDist_i, .relDist_u, .relDist_a, .vtl, .duration, .intensity, .slope
	# Uses global variable
	if output_table$ = "-"
		appendInfoLine: title$, tab$, .sp$, tab$, .numVowelIntervals, tab$, fixed$(.area2perc, 1), tab$, fixed$(.area1perc, 1), tab$, fixed$(.relDist_i, 1), tab$, fixed$(.relDist_u, 1), tab$, fixed$(.relDist_a, 1), tab$, fixed$(.vtl, 2), tab$, fixed$(.duration,0), tab$, fixed$(.intensity,1), tab$, fixed$(.slope,1), tab$, plotFormantAlgorithm$
	elsif index_regex(output_table$, "\w")
		appendFileLine: output_table$, title$, tab$, .sp$, tab$, .numVowelIntervals, tab$, fixed$(.area2perc, 1), tab$, fixed$(.area1perc, 1), tab$, fixed$(.relDist_i, 1), tab$, fixed$(.relDist_u, 1), tab$, fixed$(.relDist_a, 1), tab$, fixed$(.vtl, 2), tab$, fixed$(.duration,0), tab$, fixed$(.intensity,1), tab$, fixed$(.slope,1), tab$, plotFormantAlgorithm$
	endif	
endproc

# Plot the standard vowels
procedure plot_standard_vowel .color$ .sp$ .vowel$ .reduction
	.vowel$ = replace_regex$(.vowel$, "v", "y", 0)

	.i = 0
	while .vowel$ <> ""
		.i += 1
		.v$ = replace_regex$(.vowel$, "^\s*(\S[`]?).*$", "\1", 0)
		.f1 = phonemes [plotFormantAlgorithm$, .sp$, .v$, "F1"]
		.f2 = phonemes [plotFormantAlgorithm$, .sp$, .v$, "F2"]
		if .reduction
			.factor = 0.9^.reduction
			.f1 = .factor * (.f1 - phonemes [plotFormantAlgorithm$, .sp$, "@", "F1"]) + phonemes [plotFormantAlgorithm$, .sp$, "@", "F1"]
			.f2 = .factor * (.f2 - phonemes [plotFormantAlgorithm$, .sp$, "@", "F2"]) + phonemes [plotFormantAlgorithm$, .sp$, "@", "F2"]
		endif
		@vowel2point: 1, plotFormantAlgorithm$, .sp$, .f1, .f2
		.x [.i] = vowel2point.x
		.y [.i] = vowel2point.y
		.vowel$ = replace_regex$(.vowel$, "^\s*(\S[`]?)", "", 0)
	endwhile
	Arrow size: 2
	Green
	Dotted line
	Paint circle: .color$, .x[1], .y[1], 1
	for .p from 2 to .i
		Draw arrow: .x[.p - 1], .y[.p - 1], .x[.p], .y[.p]
	endfor
	demoShow()
	Black
endproc

# Plot the vowel triangle
procedure plot_vowel_triangle .sp$
	# Draw vowel triangle
	.a_F1 = phonemes [plotFormantAlgorithm$, .sp$, "a_corner", "F1"]
	.a_F2 = phonemes [plotFormantAlgorithm$, .sp$, "a_corner", "F2"]

	.i_F1 = phonemes [plotFormantAlgorithm$, .sp$, "i_corner", "F1"]
	.i_F2 = phonemes [plotFormantAlgorithm$, .sp$, "i_corner", "F2"]

	.u_F1 = phonemes [plotFormantAlgorithm$, .sp$, "u_corner", "F1"]
	.u_F2 = phonemes [plotFormantAlgorithm$, .sp$, "u_corner", "F2"]
	
	Dashed line
	# u - i
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .u_F1, .u_F2
	.x1 = vowel2point.x
	.y1 = vowel2point.y
	Colour: color$ ["u"]
	Text special: .x1, "Centre", .y1, "Bottom", "Helvetica", 20, "0", "/u/ "+uiMessage$ [uiLanguage$, "Corneru"]
	Black
	
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .i_F1, .i_F2
	.x2 = vowel2point.x
	.y2 = vowel2point.y
	Colour: color$ ["i"]
	Text special: .x2, "Centre", .y2, "Bottom", "Helvetica", 20, "0", uiMessage$ [uiLanguage$, "Corneri"]+" /i/"
	Black
	Draw line: .x1, .y1, .x2, .y2
	
	# u - a
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .u_F1, .u_F2
	.x1 = vowel2point.x
	.y1 = vowel2point.y
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .a_F1, .a_F2
	.x2 = vowel2point.x
	.y2 = vowel2point.y
	Colour: color$ ["a"]
	Text special: .x2, "Centre", .y2, "Top", "Helvetica", 20, "0", "/a/ "+uiMessage$ [uiLanguage$, "Cornera"]
	Black
	Draw line: .x1, .y1, .x2, .y2
	
	# i - a
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .i_F1, .i_F2
	.x1 = vowel2point.x
	.y1 = vowel2point.y
	@vowel2point: 1, plotFormantAlgorithm$, .sp$, .a_F1, .a_F2
	.x2 = vowel2point.x
	.y2 = vowel2point.y
	Draw line: .x1, .y1, .x2, .y2
endproc

# Convert the frequencies to coordinates
procedure vowel2point .scaling .targetFormantAlgorithm$ .sp$ .f1 .f2
	.scaleSt = 12*log2(.scaling)
	
	if .f1=undefined or .f2=undefined or .f1 <= 0 or .f2 <= 0
		.x = -1
		.y = -1
		
		goto ENDOFVowel2point
	endif

	.spt1 = 12*log2(.f1)
	.spt2 = 12*log2(.f2)
	
	# Apply correction
	.spt1 += .scaleSt
	.spt2 += .scaleSt
	
	.a_St1 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "a_corner", "F1"])
	.a_St2 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "a_corner", "F2"])

	.i_St1 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "i_corner", "F1"])
	.i_St2 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "i_corner", "F2"])

	.u_St1 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "u_corner", "F1"])
	.u_St2 = 12*log2(phonemes [.targetFormantAlgorithm$, .sp$, "u_corner", "F2"])
	
	.dist_iu = sqrt((.i_St1 - .u_St1)^2 + (.i_St2 - .u_St2)^2)
	.theta = arcsin((.u_St1 - .i_St1)/.dist_iu)

	# First, with i_corner as (0, 0)
	.xp = ((.i_St2 - .spt2)/(.i_St2 - .u_St2))
	.yp = (.spt1 - min(.u_St1, .i_St1))/(.a_St1 - min(.u_St1, .i_St1))
	
	# Rotate around i_corner to make i-u axis horizontal
	.x = .xp * cos(.theta) + .yp * sin(.theta)
	.y = -1 * .xp * sin(.theta) + .yp * cos(.theta)
	
	# Reflect y-axis and make i_corner as (0, 1)
	.y = 1 - .y
	.yp = 1 - .yp
	
	label ENDOFVowel2point
endproc

# Stop the progam
procedure exitVowelTriangle .message$
	select all
	if numberOfSelected() > 0
		Remove
	endif
	exitScript: .message$
endproc

# Get a list of best targets with distances, one for each vowel segment found
# Use DTW to get the best match
procedure get_closest_vowels .cutoff .sp$ .formants .formantsPlot .textgrid .f1_o .f2_o .scaling
	.f1 = 0
	.f2 = 0
	
	# Convert to coordinates
	@vowel2point: 1, targetFormantAlgorithm$, .sp$, .f1_o, .f2_o
	.st_o1 = vowel2point.x
	.st_o2 = vowel2point.y
	
	# Get center coordinates
	.fc1 = phonemes [targetFormantAlgorithm$, .sp$, "@_center", "F1"]
	.fc2 = phonemes [targetFormantAlgorithm$, .sp$, "@_center", "F2"]
	@vowel2point: 1, targetFormantAlgorithm$, .sp$, .fc1, .fc2
	.st_c1 = vowel2point.x
	.st_c2 = vowel2point.y
	.tcDist_sqr = (.st_o1 - .st_c1)^2 + (.st_o2 - .st_c2)^2

	.vowelTier = 1
	.vowelNum = 0
	selectObject: .textgrid
	.numIntervals = Get number of intervals: .vowelTier
	.tableDistances = -1
	for .i to .numIntervals
		selectObject: .textgrid
		.label$ = Get label of interval: .vowelTier, .i
		if .label$ = "Vowel"
			.numDistance = 100000000000
			.numF1 = -1
			.numF2 = -1
			.num_t = 0
			selectObject: .textgrid
			.start = Get start time of interval: .vowelTier, .i
			.end = Get end time of interval: .vowelTier, .i
			selectObject: .formants
			.t = .start
			while .t <= .end
				.ftmp1 = Get value at time: 1, .t, "Hertz", "Linear"
				.ftmp2 = Get value at time: 2, .t, "Hertz", "Linear"
				@vowel2point: .scaling, targetFormantAlgorithm$, .sp$, .ftmp1, .ftmp2
				.stmp1 = vowel2point.x
				.stmp2 = vowel2point.y
				.tmpdistsqr = (.st_o1 - .stmp1)^2 + (.st_o2 - .stmp2)^2
				# Local
				if .tmpdistsqr < .numDistance
					.numDistance = .tmpdistsqr
					.numF1 = .ftmp1
					.numF2 = .ftmp2
					.num_t = .t
					.numF3 = Get value at time: 3, .num_t, "Hertz", "Linear"
					.numF4 = Get value at time: 4, .num_t, "Hertz", "Linear"
					.numF5 = Get value at time: 5, .num_t, "Hertz", "Linear"
				endif
				.t += 0.005
			endwhile
			
			# Convert to "real" (Burg) formant values
			if .formants != .formantsPlot
				selectObject: .formantsPlot
				.numF1 = Get value at time: 1, .num_t, "Hertz", "Linear"
				.numF2 = Get value at time: 2, .num_t, "Hertz", "Linear"
				.numF3 = Get value at time: 3, .num_t, "Hertz", "Linear"
				.numF4 = Get value at time: 4, .num_t, "Hertz", "Linear"
				.numF5 = Get value at time: 5, .num_t, "Hertz", "Linear"
			endif
			
			# Calculate the distance along the line between the 
			# center (c) and the target (t) from the best match 'v'
			# to the center.
			# 
			@vowel2point: .scaling, plotFormantAlgorithm$, .sp$, .numF1, .numF2
			.st1 = vowel2point.x
			.st2 = vowel2point.y
			
			.vcDist_sqr = (.st_c1 - .st1)^2 + (.st_c2 - .st2)^2
			.vtDist_sqr = (.st_o1 - .st1)^2 + (.st_o2 - .st2)^2
			.cvDist = (.tcDist_sqr + .vcDist_sqr - .vtDist_sqr)/(2*sqrt(.tcDist_sqr))
			
			# Only use positive distances for plotting
			if .cvDist = undefined or .cvDist >= .cutoff
				.vowelNum += 1
				.distance_list [.vowelNum] = sqrt(.numDistance)
				.f1_list [.vowelNum] = .numF1
				.f2_list [.vowelNum] = .numF2
				.f3_list [.vowelNum] = .numF3
				.f4_list [.vowelNum] = .numF4
				.f5_list [.vowelNum] = .numF5
				.t_list [.vowelNum] = .num_t
	
				if .tableDistances <= 0
					.tableDistances = Create TableOfReal: "Distances", 1, 1
				else
					selectObject: .tableDistances
					Insert row (index): 1
				endif
				selectObject: .tableDistances
				Set value: 1, 1, .cvDist
			endif
		endif
	endfor
	.meanDistance = -1
	.stdevDistance = -1
	if .tableDistances > 0
		selectObject: .tableDistances
		.meanDistance = Get column mean (index): 1
		.stdevDistance = Get column stdev (index): 1
		if .stdevDistance = undefined
			.stdevDistance = .meanDistance/2
		endif
		Remove
	endif
endproc

# Collect all the most distant vowels
procedure get_most_distant_vowels .sp$ .formants .textgrid .f1_o .f2_o .scaling
	.f1 = 0
	.f2 = 0
	
	# Convert to coordinates
	@vowel2point: 1, targetFormantAlgorithm$, .sp$, .f1_o, .f2_o
	.st_o1 = vowel2point.x
	.st_o2 = vowel2point.y
	
	.vowelTier = 1
	.vowelNum = 0
	selectObject: .textgrid
	.numIntervals = Get number of intervals: .vowelTier
	for .i to .numIntervals
		selectObject: .textgrid
		.label$ = Get label of interval: .vowelTier, .i
		if .label$ = "Vowel"
			.vowelNum += 1
			.numDistance = -1
			.numF1 = -1
			.numF2 = -1
			.num_t = 0
			selectObject: .textgrid
			.start = Get start time of interval: .vowelTier, .i
			.end = Get end time of interval: .vowelTier, .i
			selectObject: .formants
			.t = .start
			while .t <= .end
				.ftmp1 = Get value at time: 1, .t, "Hertz", "Linear"
				.ftmp2 = Get value at time: 2, .t, "Hertz", "Linear"
				@vowel2point: .scaling, targetFormantAlgorithm$, .sp$, .ftmp1, .ftmp2
				.stmp1 = vowel2point.x
				.stmp2 = vowel2point.y
				.tmpdistsqr = (.st_o1 - .stmp1)^2 + (.st_o2 - .stmp2)^2
				# Local
				if .tmpdistsqr > .numDistance
					.numDistance = .tmpdistsqr
					.numF1 = .ftmp1
					.numF2 = .ftmp2
					.num_t = .t
				endif
				.t += 0.005
			endwhile

			.distance_list [.vowelNum] = sqrt(.numDistance)
			.f1_list [.vowelNum] = .numF1
			.f2_list [.vowelNum] = .numF2
			.t_list [.vowelNum] = .num_t
		endif
	endfor
endproc

procedure select_vowel_target .sp$ .sound .formants .formantsBandwidth .textgrid
	
	.vowelTier = 1
	.targetTier = 2
	.peakTier = 3
	.valleyTier = 4
	.silencesTier = 5
	.vuvTier = 6
	
	selectObject: .textgrid
	.duration = Get total duration
	.firstTier$ = Get tier name: 1
	if .firstTier$ <> "Vowel"
		Insert point tier: 1, "VowelTarget"
		Insert interval tier: 1, "Vowel"
	else
	 	.numTiers = Get number of tiers
		if .numTiers <= 2
			goto TEXTGRIDREADY
		endif
	endif
	
	.f1_Lowest = phonemes [targetFormantAlgorithm$, .sp$, "i_corner", "F1"]
	.f1_Highest = (1050/900) * phonemes [targetFormantAlgorithm$, .sp$, "a_corner", "F1"]

	selectObject: .sound
	.samplingFrequency = Get sampling frequency
	.intensity = Get intensity (dB)
	selectObject: .formantsBandwidth
	.totalNumFrames = Get number of frames
		
	# Nothing found, but there is sound. Try to find at least 1 vowel
	
	selectObject: .textgrid
	.numPeaks = Get number of points: .peakTier	
	if .numPeaks <= 0 and .intensity >= 45
		selectObject: .sound
		.t_max = Get time of maximum: 0, 0, "Sinc70"
		.pp = noprogress To PointProcess (periodic, cc): 75, 600
		.textGrid = noprogress To TextGrid (vuv): 0.02, 0.01
		.i = Get interval at time: 1, .t_max
		.label$ = Get label of interval: 1, .i
		.start = Get start time of interval: 1, .i
		.end = Get end time of interval: 1, .i
		if .label$ = "V"
			selectObject: .syllableKernels
			Insert point: .peakTier, .t_max, "P"
			Insert point: .valleyTier, .start, "V"
			Insert point: .valley, .end, "V"
		endif
	endif
	
	selectObject: .sound
	.voicePP = noprogress To PointProcess (periodic, cc): 75, 600
	selectObject: .textgrid
	.numPeaks = Get number of points: .peakTier
	.numValleys = Get number of points: .valleyTier
	for .p to .numPeaks
		selectObject: .textgrid
		.tp = Get time of point: .peakTier, .p
		# Find boundaries
		# From valleys
		.tl = 0
		.vl = Get low index from time: .valleyTier, .tp
		if .vl > 0 and .vl < .numValleys
			.tl = Get time of point: .valleyTier, .vl
		endif
		.th = .duration
		.vh = Get high index from time: .valleyTier, .tp
		if .vh > 0 and .vh < .numValleys
			.th = Get time of point: .valleyTier, .vh
		endif
		# From silences
		.sl = Get interval at time: .silencesTier, .tl
		.label$ = Get label of interval: .silencesTier, .sl
		.tsl = .tl
		if .label$ = "silent"
			.tsl = Get end time of interval: .silencesTier, .sl
		endif
		if .tsl > .tl and .tsl < .tp
			.tl = .tsl
		endif
		.sh = Get interval at time: .silencesTier, .th
		.label$ = Get label of interval: .silencesTier, .sh
		.tsh = .th
		if .label$ = "silent"
			.tsh = Get start time of interval: .silencesTier, .sh
		endif
		if .tsh < .th and .tsh > .tp
			.th = .tsh
		endif
		
		# From vuv
		.vuvl = Get interval at time: .vuvTier, .tl
		.label$ = Get label of interval: .vuvTier, .vuvl
		.tvuvl = .tl
		if .label$ = "U"
			.tvuvl = Get end time of interval: .vuvTier, .vuvl
		endif
		if .tvuvl > .tl and .tvuvl < .tp
			.tl = .tvuvl
		endif
		.vuvh = Get interval at time: .vuvTier, .th
		.label$ = Get label of interval: .vuvTier, .vuvh
		.tvuvh = .th
		if .label$ = "U"
			.tvuvh = Get start time of interval: .vuvTier, .vuvh
		endif
		if .tvuvh < .th and .tvuvh > .tp
			.th = .tvuvh
		endif
		
		# From formants: 300 <= F1 <= 1000
		# F1 >= 300
		selectObject: .formants
		.dt = Get time step

		selectObject: .formants
		.f = Get value at time: 1, .tl, "Hertz", "Linear"
		selectObject: .formantsBandwidth
		.b = Get bandwidth at time: 1, .tl, "Hertz", "Linear"
		.iframe = Get frame number from time: .tl
		.iframe = round(.iframe)
		if .iframe > .totalNumFrames
			.iframe = .totalNumFrames
		elsif .iframe < 1
			.iframe = 1
		endif
		.nf = Get number of formants: .iframe
		while (.f < .f1_Lowest or .f > .f1_Highest or .b > 0.7 * .f or .nf < 4) and .tl + .dt < .th
			.tl += .dt
			selectObject: .formants
			.f = Get value at time: 1, .tl, "Hertz", "Linear"
			selectObject: .formantsBandwidth
			.b = Get bandwidth at time: 1, .tl, "Hertz", "Linear"
			.iframe = Get frame number from time: .tl	
			.iframe = round(.iframe)
			if .iframe > .totalNumFrames
				.iframe = .totalNumFrames
			elsif .iframe < 1
				.iframe = 1
			endif
			.nf = Get number of formants: .iframe		
		endwhile

		selectObject: .formants
		.f = Get value at time: 1, .th, "Hertz", "Linear"
		selectObject: .formantsBandwidth
		.b = Get bandwidth at time: 1, .th, "Hertz", "Linear"
		.iframe = Get frame number from time: .th
		.iframe = round(.iframe)
		if .iframe > .totalNumFrames
			.iframe = .totalNumFrames
		elsif .iframe < 1
			.iframe = 1
		endif
		.nf = Get number of formants: .iframe
		while (.f < .f1_Lowest or .f > .f1_Highest or .b > 0.7 * .f or .nf < 4) and .th - .dt > .tl
			.th -= .dt
			selectObject: .formants
			.f = Get value at time: 1, .th, "Hertz", "Linear"
			selectObject: .formantsBandwidth
			.b = Get bandwidth at time: 1, .th, "Hertz", "Linear"
			.iframe = Get frame number from time: .th
			.iframe = round(.iframe)
			if .iframe > .totalNumFrames
				.iframe = .totalNumFrames
			elsif .iframe < 1
				.iframe = 1
			endif
			.nf = Get number of formants: .iframe		
		endwhile
		
		# New points
		if .th - .tl > 0.01
			selectObject: .textgrid
			.numPoints = Get number of points: .targetTier
			
			selectObject: .formants
			if .tp > .tl and .tp < .th
				.tt = .tp
			else
				.tt = (.tl+.th)/2
				.f1_median = Get quantile: 1, .tl, .th, "Hertz", 0.5 
				.f2_median = Get quantile: 2, .tl, .th, "Hertz", 0.5 
				if .f1_median > 400
					.tt = Get time of maximum: 1, .tl, .th, "Hertz", "Parabolic"
				elsif .f2_median > 1600
					.tt = Get time of maximum: 2, .tl, .th, "Hertz", "Parabolic"
				elsif .f2_median < 1100
					.tt = Get time of minimum: 2, .tl, .th, "Hertz", "Parabolic"
				endif
				
				if .tt < .tl + 0.01 or .tt > .th - 0.01
					.tt = (.tl+.th)/2
				endif
			endif
			
			# Insert Target
			selectObject: .textgrid
			.numPoints = Get number of points: .targetTier
			.tmp = 0
			if .numPoints > 0
				.tmp = Get time of point: .targetTier, .numPoints
			endif
			if .tt <> .tmp
				Insert point: .targetTier, .tt, "T"
			endif
			
			# Now find vowel interval from taget
			.ttl = .tt
			# Lower end
			selectObject: .formants
			.f = Get value at time: 1, .ttl, "Hertz", "Linear"
			selectObject: .formantsBandwidth
			.b = Get bandwidth at time: 1, .ttl, "Hertz", "Linear"
			.iframe = Get frame number from time: .th
			.iframe = round(.iframe)
			if .iframe > .totalNumFrames
				.iframe = .totalNumFrames
			elsif .iframe < 1
				.iframe = 1
			endif
			.nf = Get number of formants: .iframe	
			
			# Voicing: Is there a voiced point below within 0.02 s?
			selectObject: .voicePP
			.i_near = Get nearest index: .ttl - .dt
			.pp_near = Get time from index: .i_near
			
			while (.f > .f1_Lowest and .f < .f1_Highest and .b < 0.9 * .f and .nf >= 4) and .ttl - .dt >= .tl and abs((.ttl - .dt) - .pp_near) <= 0.02
				.ttl -= .dt
				selectObject: .formants
				.f = Get value at time: 1, .ttl, "Hertz", "Linear"
				selectObject: .formantsBandwidth
				.b = Get bandwidth at time: 1, .ttl, "Hertz", "Linear"
				.iframe = Get frame number from time: .ttl
				.iframe = round(.iframe)
				if .iframe > .totalNumFrames
					.iframe = .totalNumFrames
				elsif .iframe < 1
					.iframe = 1
				endif
				.nf = Get number of formants: .iframe
				# Voicing: Is there a voiced point below within 0.02 s?
				selectObject: .voicePP
				.i_near = Get nearest index: .ttl - .dt
				.pp_near = Get time from index: .i_near
			endwhile
			# Make sure something has changed
			if .ttl > .tt - 0.01
				.ttl = .tl
			endif
			
			# Higher end
			.tth = .tp
			selectObject: .formants
			.f = Get value at time: 1, .tth, "Hertz", "Linear"
			selectObject: .formantsBandwidth
			.b = Get bandwidth at time: 1, .tth, "Hertz", "Linear"
			.iframe = Get frame number from time: .th
			.iframe = round(.iframe)
			if .iframe > .totalNumFrames
				.iframe = .totalNumFrames
			elsif .iframe < 1
				.iframe = 1
			endif
			.nf = Get number of formants: .iframe		
			
			# Voicing: Is there a voiced point above within 0.02 s?
			selectObject: .voicePP
			.i_near = Get nearest index: .ttl + .dt
			.pp_near = Get time from index: .i_near
			
			while (.f > .f1_Lowest and .f < .f1_Highest and .b < 0.9 * .f and .nf >= 4) and .tth + .dt <= .th and abs((.ttl + .dt) - .pp_near) <= 0.02
				.tth += .dt
				selectObject: .formants
				.f = Get value at time: 1, .tth, "Hertz", "Linear"
				selectObject: .formantsBandwidth
				.b = Get bandwidth at time: 1, .tth, "Hertz", "Linear"
				.iframe = Get frame number from time: .tth
				.iframe = round(.iframe)
				if .iframe > .totalNumFrames
					.iframe = .totalNumFrames
				elsif .iframe < 1
					.iframe = 1
				endif
				.nf = Get number of formants: .iframe		
				# Voicing: Is there a voiced point above within 0.02 s?
				selectObject: .voicePP
				.i_near = Get nearest index: .ttl + .dt
				.pp_near = Get time from index: .i_near
			endwhile
			# Make sure something has changed
			if .tth < .tt + 0.01
				.tth = .th
			endif
			
			# Insert interval
			selectObject: .textgrid
			.index = Get interval at time: .vowelTier, .ttl
			.start = Get start time of interval: .vowelTier, .index
			.end = Get end time of interval: .vowelTier, .index
			if .ttl <> .start and .ttl <> .end
				Insert boundary: .vowelTier, .ttl
			endif
			.index = Get interval at time: .vowelTier, .tth
			.start = Get start time of interval: .vowelTier, .index
			.end = Get end time of interval: .vowelTier, .index
			if .tth <> .start and .tth <> .end
				Insert boundary: .vowelTier, .tth
			endif
			.index = Get interval at time: .vowelTier, .tt
			.start = Get start time of interval: .vowelTier, .index
			.end = Get end time of interval: .vowelTier, .index
			# Last sanity checks on voicing and intensity
			# A vowel is voiced
			selectObject: .voicePP
			.meanPeriod = Get mean period: .start, .end, 0.0001, 0.02, 1.3
			if .meanPeriod <> undefined
				selectObject: .sound
				.sd = Get standard deviation: 1, .start, .end
				# Is there enough sound to warrant a vowel? > -15dB
				if 20*log10(.sd/(2*10^-5)) - .intensity > -15
					selectObject: .textgrid
					Set interval text: .vowelTier, .index, "Vowel"
				endif
			endif
		endif
	endfor
	
	selectObject: .voicePP
	Remove
	
	label TEXTGRIDREADY
endproc


###########################################################################
#                                                                         #
#  Praat Script Syllable Nuclei                                           #
#  Copyright (C) 2017  R.J.J.H. van Son                                   #
#                                                                         #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 2 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
###########################################################################
#                                                                         #
# Simplified summary of the script by Nivja de Jong and Ton Wempe         #
#                                                                         #
# Praat script to detect syllable nuclei and measure speech rate          # 
# automatically                                                           #
# de Jong, N.H. & Wempe, T. Behavior Research Methods (2009) 41: 385.     #
# https://doi.org/10.3758/BRM.41.2.385                                    #
# 
procedure segment_syllables .silence_threshold .minimum_dip_between_peaks .minimum_pause_duration .keep_Soundfiles_and_Textgrids .soundid
	# Get intensity
	selectObject: .soundid
	.intensity = noprogress To Intensity: 70, 0, "yes"
	.dt = Get time step
	.maxFrame = Get number of frames
	
	# Determine Peaks
	selectObject: .intensity
	.peaksInt = noprogress To IntensityTier (peaks)
	.peaksPoint = Down to PointProcess
	.peaksPointTier = Up to TextTier: "P"
	Rename: "Peaks"
	
	# Determine valleys
	selectObject: .intensity
	.valleyInt = noprogress To IntensityTier (valleys)
	.valleyPoint = Down to PointProcess
	.valleyPointTier = Up to TextTier: "V"
	Rename: "Valleys"
	
	selectObject: .peaksPointTier, .valleyPointTier
	.segmentTextGrid = Into TextGrid
	
	selectObject: .peaksPointTier, .valleyPointTier, .peaksInt, .peaksPoint, .valleyInt, .valleyPoint
	Remove
	
	# Select the sounding part
	selectObject: .intensity
	.silenceTextGrid = noprogress To TextGrid (silences): .silence_threshold, .minimum_pause_duration, 0.05, "silent", "sounding"
	
	# Determine voiced parts
	selectObject: .soundid
	.voicePP = noprogress To PointProcess (periodic, cc): 75, 600
	.vuvTextGrid = noprogress To TextGrid (vuv): 0.02, 0.01
	plusObject: .segmentTextGrid, .silenceTextGrid
	.textgridid = Merge
	
	selectObject: .vuvTextGrid, .silenceTextGrid, .segmentTextGrid, .voicePP
	Remove
	
	# Remove irrelevant peaks and valleys
	selectObject: .textgridid
	.numPeaks = Get number of points: 1
	for .i to .numPeaks
		.t = Get time of point: 1, .numPeaks + 1 - .i
		.s = Get interval at time: 3, .t
		.soundLabel$ = Get label of interval: 3, .s
		.v = Get interval at time: 4, .t
		.voiceLabel$ = Get label of interval: 4, .v
		if .soundLabel$ = "silent" or .voiceLabel$ = "U"
			Remove point: 1, .numPeaks + 1 - .i
		endif
	endfor
	
	# valleys
	selectObject: .textgridid
	.numValleys = Get number of points: 2
	.numPeaks = Get number of points: 1
	# No peaks, nothing to do
	if .numPeaks <= 0
		goto VALLEYREADY
	endif
	
	for .i from 2 to .numValleys
		selectObject: .textgridid
		.il = .numValleys + 1 - .i
		.ih = .numValleys + 2 - .i
		.tl = Get time of point: 2, .il
		.th = Get time of point: 2, .ih
		
		
		.ph = Get high index from time: 1, .tl
		.tph = 0
		if .ph > 0 and .ph <= .numPeaks
			.tph = Get time of point: 1, .ph
		endif
		# If there is no peak between the valleys remove the highest
		if .tph <= 0 or (.tph < .tl or .tph > .th)
			# If the area is silent for both valleys, keep the one closest to a peak
			.psl = Get interval at time: 3, .tl
			.psh = Get interval at time: 3, .th
			.psl_label$ = Get label of interval: 3, .psl
			.psh_label$ = Get label of interval: 3, .psh
			if .psl_label$ = "silent" and .psh_label$ = "silent"
				.plclosest = Get nearest index from time: 1, .tl
				if .plclosest <= 0
					.plclosest = 1
				endif
				if .plclosest > .numPeaks
					.plclosest = .numPeaks
				endif
				.tlclosest = Get time of point: 1, .plclosest
				.phclosest = Get nearest index from time: 1, .th
				if .phclosest <= 0
					.phclosest = 1
				endif
				if .phclosest > .numPeaks
					.phclosest = .numPeaks
				endif
				.thclosest = Get time of point: 1, .phclosest
				if abs(.tlclosest - .tl) > abs(.thclosest - .th)
					selectObject: .textgridid
					Remove point: 2, .il
				else
					selectObject: .textgridid
					Remove point: 2, .ih
				endif
			else
				# Else Compare valley depths
				selectObject: .intensity
				.intlow = Get value at time: .tl, "Cubic"
				.inthigh = Get value at time: .th, "Cubic"
				if .inthigh >= .intlow
					selectObject: .textgridid
					Remove point: 2, .ih
				else
					selectObject: .textgridid
					Remove point: 2, .il
				endif
			endif
		endif
	endfor

	# Remove superfluous valleys
	selectObject: .textgridid
	.numValleys = Get number of points: 2
	.numPeaks = Get number of points: 1
	for .i from 1 to .numValleys
		selectObject: .textgridid
		.iv = .numValleys + 1 - .i
		.tv = Get time of point: 2, .iv
		.ph = Get high index from time: 1, .tv
		if .ph > .numPeaks
			.ph = .numPeaks
		endif
		.tph = Get time of point: 1, .ph
		.pl = Get low index from time: 1, .tv
		if .pl <= 0
			.pl = 1
		endif
		.tpl = Get time of point: 1, .pl
		
		# Get intensities
		selectObject: .intensity
		.v_int = Get value at time: .tv, "Cubic"
		.pl_int = Get value at time: .tpl, "Cubic"
		.ph_int = Get value at time: .tph, "Cubic"
		# If there is no real dip, remove valey and lowest peak
		if min((.pl_int - .v_int), (.ph_int - .v_int)) < .minimum_dip_between_peaks
			selectObject: .textgridid
			Remove point: 2, .iv
			if .ph <> .pl
				if .pl_int < .ph_int
					Remove point: 1, .pl
				else
					Remove point: 1, .ph
				endif
			endif
			.numPeaks = Get number of points: 1
			if .numPeaks <= 0
				goto VALLEYREADY
			endif
		endif
	endfor
	label VALLEYREADY
	
	selectObject: .intensity
	Remove
	
	selectObject: .textgridid
endproc

#
# Vocal Tract Length according to:
# Lammert, Adam C., and Shrikanth S. Narayanan. 
# “On Short-Time Estimation of Vocal Tract Length from Formant Frequencies.” 
# Edited by Charles R Larson. PLOS ONE 10, no. 7 (July 15, 2015): e0132193. 
# https://doi.org/10.1371/journal.pone.0132193.
#
# Iteratively, uses closest approach to (F1, F2) = (Phi, 3*Phi)
# 
procedure estimate_Vocal_Tract_Length .formants .syllableKernels .targetTier
	# Coefficients
	.beta[0] = 229
	.beta[1] = 0.030
	.beta[2] = 0.082
	.beta[3] = 0.124
	.beta[4] = 0.354
	
	.sp$ = "F"
	.phi = 500
	.vtl = -1
	
	.numTargets = -1
	for .iteration to 5
		@get_closest_vowels: -24, .sp$, .formants, .formants, .syllableKernels, .phi, 3*.phi, 1
		
		.numTargets = get_closest_vowels.vowelNum
		.n = 0
		.sumVTL = 0
		for .p to .numTargets
			.currentPhi = .beta[0]
			for .i to 4
				.f[.i] =  get_closest_vowels.f'.i'_list [.p]
				if .f[.i] <> undefined and .currentPhi <> undefined
					.currentPhi += .beta[.i] * .f[.i] / (2*.i - 1)
				else
					.currentPhi = undefined
				endif
			endfor
			if .currentPhi <> undefined
				.currentVTL = 100 * 352.95 / (4*.currentPhi)
				.sumVTL += .currentVTL
				.n += 1
			endif
		endfor
		
		if .n > 0
			.vtl = .sumVTL / .n
			# L = c / (4*Phi) (cm)
			.phi = 100 * 352.95 / (4*.vtl)
			
			.sp$ = "F"
			if .phi < averagePhi_VTL [plotFormantAlgorithm$, "A"]
				.sp$ = "M"
			endif
		endif
	endfor
endproc


# 
# Determine COG as an intensity
#
# .cog_Matrix = Down to Matrix
# call calculateCOG .dt .soundid
# .cog_Tier = calculateCOG.cog_tier
# selectObject: .cog_Tier
# .numPoints = Get number of points
# for .i to .numPoints
# 	selectObject: .cog_Tier
# 	.cog = Get value at index: .i
# 	.t = Get time from index: .i
# 	selectObject: .intensity
# 	.c = Get frame number from time: .t
# 	if .c >= 0.5 and .c <= .maxFrame
# 		selectObject: .cog_Matrix
# 		Set value: 1, round(.c), .cog
# 	endif
# endfor
# selectObject: .cog_Matrix
# .cogIntensity = noprogress To Intensity

procedure calculateCOG .dt .sound
	selectObject: .sound
	.duration = Get total duration
	if .dt <= 0 or .dt > .sound
		.dt = 0.01
	endif
	
	# Create Spectrogram
	selectObject: .sound
	.spectrogram = noprogress To Spectrogram: 0.005, 8000, 0.002, 20, "Gaussian"
	.cog_tier = Create IntensityTier: "COG", 0.0, .duration
	
	.t = .dt / 2
	while .t < .duration
		selectObject: .spectrogram
		.spectrum = noprogress To Spectrum (slice): .t
		.cog_t = Get centre of gravity: 2
		selectObject: .cog_tier
		Add point: .t, .cog_t
		
		.t += .dt
		
		selectObject: .spectrum
		Remove
	endwhile
	
	selectObject: .spectrogram
	Remove
endproc

# Initialize missing columns. Column names ending with a $ are text
procedure initialize_table_collumns .table, .columns$, .initial_value$
	.columns$ = replace_regex$(.columns$, "^\W+", "", 0)
	selectObject: .table
	.numRows = Get number of rows
	while .columns$ <> ""
		.label$ = replace_regex$(.columns$, "^\W*(\w+)\W.*$", "\1", 0)
		.columns$ = replace_regex$(.columns$, "^\W*(\w+)", "", 0)
		.textType = startsWith(.columns$, "$")
		if not .textType and index_regex(.initial_value$, "[0-9]") <= 0
			.textType = 1
		endif
		.columns$ = replace_regex$(.columns$, "^\W+", "", 0)
		.col = Get column index: .label$
		if .col <= 0
			Append column: .label$
			for .r to .numRows
				if .textType
					Set string value: .r, .label$, .initial_value$
				else
					Set value: .r, .label$, '.initial_value$'
				endif
			endfor
		endif
	endwhile
endproc
