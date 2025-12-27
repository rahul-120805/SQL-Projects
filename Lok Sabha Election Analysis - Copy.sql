--Lok Sabha Result Analysis SQL Project 
USE [Lok Sabha Election Database];

--Total Seats
SELECT COUNT(*) FROM constituencywise_results;



--Total Number of Seats Availaible for Election in each state
SELECT s.state AS State_Name,
t.state_id AS state_id,
COUNT(t.parliament_constituency) AS Total_seats
FROM statewise_results AS t
INNER JOIN states AS s 
ON s.State_ID = t.State_ID
GROUP BY t.state_id,s.state
ORDER BY s.state;


--Total Seats Won By NDA Alliance (without adding a new column in partywise_results)
SELECT SUM(CASE
WHEN party IN('Bharatiya Janata Party - BJP', 
                'Telugu Desam - TDP', 
				'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS', 
                'AJSU Party - AJSUP', 
                'Apna Dal (Soneylal) - ADAL', 
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS', 
                'Janasena Party - JnP', 
				'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV', 
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD', 
                'Sikkim Krantikari Morcha - SKM')
				THEN WON
				ELSE 0
				END )
AS Seats_won_by_NDA
FROM partywise_results;


--Total Seats Won By I.N.D.I.A alliance
SELECT SUM(CASE WHEN party IN ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')

				THEN won
				ELSE 0 
				END )
AS Total_seats_won_by_INDIA_alliance
FROM partywise_results;




-- Total Seats won by each party in NDA allaince
SELECT party AS Party_name,
won AS Seats_won
FROM partywise_results 
WHERE party IN ('Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM'
)
ORDER BY won DESC;


--Total Seats won by I.N.D.I.A Allaince
SELECT party AS party_name,
won AS seats_won
FROM partywise_results
WHERE party  IN ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK')
ORDER BY won DESC ;


--  Add a new column as alliance in partywise_results for NDA and INDIA alliance
ALTER TABLE partywise_results
ADD allaince VARCHAR(50);

UPDATE partywise_results 
SET allaince = 'NDA' 
WHERE party IN ('Bharatiya Janata Party - BJP', 
        'Telugu Desam - TDP', 
		'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS', 
        'AJSU Party - AJSUP', 
        'Apna Dal (Soneylal) - ADAL', 
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS', 
        'Janasena Party - JnP', 
		'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV', 
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD', 
        'Sikkim Krantikari Morcha - SKM');

UPDATE partywise_results
SET allaince = 'I.N.D.I.A'
WHERE party IN ('Indian National Congress - INC',
                'Aam Aadmi Party - AAAP',
                'All India Trinamool Congress - AITC',
                'Bharat Adivasi Party - BHRTADVSIP',
                'Communist Party of India  (Marxist) - CPI(M)',
                'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
                'Communist Party of India - CPI',
                'Dravida Munnetra Kazhagam - DMK',
                'Indian Union Muslim League - IUML',
                'Nat`Jammu & Kashmir National Conference - JKN',
                'Jharkhand Mukti Morcha - JMM',
                'Jammu & Kashmir National Conference - JKN',
                'Kerala Congress - KEC',
                'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
                'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
                'Rashtriya Janata Dal - RJD',
                'Rashtriya Loktantrik Party - RLTP',
                'Revolutionary Socialist Party - RSP',
                'Samajwadi Party - SP',
                'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
                'Viduthalai Chiruthaigal Katchi - VCK');


UPDATE partywise_results
SET allaince = 'Others'
WHERE allaince ISNULL;

-- Executing above querries with the alliance column
SELECT SUM(won), allaince
FROM partywise_results
GROUP BY allaince;


--Which party alliance won the most seats across all states
SELECT SUM(won) AS seats_won, allaince
FROM partywise_results
GROUP BY allaince
ORDER BY seats_won DESC;


-- Winning Candidates Name, party , total_votes , margin of votes for a specific state and constituency ##

SELECT cr.Winning_Candidate, p.Party, p.allaince, cr.Total_Votes, cr.Margin, cr.Constituency_Name, s.State
FROM constituencywise_results cr
JOIN partywise_results p ON cr.Party_ID = p.Party_ID
JOIN statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE s.State = 'Uttar Pradesh' AND cr.Constituency_Name = 'Varanasi';


--Distribution of Total EVM votes and postal votes for candidates in a specific constituency

SELECT s.candidate,s.party,t.Constituency_Name,s.evm_votes,s.postal_votes
FROM constituencywise_details s
LEFT OUTER JOIN constituencywise_results t
ON s.Constituency_ID =t.Constituency_ID
WHERE t.Constituency_Name = 'Thane';


-- Which parties won the most seats in states , and how many seats did each party win ##
SELECT s.party, COUNT(t.Constituency_ID) AS seats_won
FROM partywise_results  AS s
INNER JOIN constituencywise_results t ON s.Party_ID = t.Party_ID
INNER JOIN statewise_results r ON t.Parliament_Constituency =r.Parliament_Constituency
INNER JOIN states w ON r.State_ID = w.State_ID
WHERE w.state = 'Jammu and Kashmir'
GROUP BY s.Party
ORDER BY seats_won DESC;


-- What is the total number of seats won by each party alliance in each state  ####
SELECT s.allaince, COUNT(t.Constituency_ID) AS seats_won,w.State
FROM partywise_results  AS s
INNER JOIN constituencywise_results t ON s.Party_ID = t.Party_ID
INNER JOIN statewise_results r ON t.Parliament_Constituency =r.Parliament_Constituency
INNER JOIN states w ON r.State_ID = w.State_ID
GROUP BY s.allaince,w.State
ORDER BY w.State;

SELECT 
    s.State AS State_Name,
    SUM(CASE WHEN p.party_alliance = 'NDA' THEN 1 ELSE 0 END) AS NDA_Seats_Won,
    SUM(CASE WHEN p.party_alliance = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
	SUM(CASE WHEN p.party_alliance = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.Party_ID = p.Party_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN 
    states s ON sr.State_ID = s.State_ID
WHERE 
    p.party_alliance IN ('NDA', 'I.N.D.I.A',  'OTHER')  -- Filter for NDA and INDIA alliances
GROUP BY 
    s.State
ORDER BY 
    s.State;


-- Which candidate recieved the highest number of votes in each constituency (top 10)
SELECT TOP 10
s.candidate,
s.party,
s.evm_votes,
t.constituency_name 
FROM constituencywise_details s
INNER JOIN constituencywise_results t ON s.Constituency_ID =t.Constituency_ID
ORDER BY s.EVM_Votes DESC;


-- Which candidate won and which one was runner up for each constituency for state in this election 
 SELECT s.leading_candidate, s.trailing_candidate, s.margin,s.constituency 
 FROM statewise_results s
 INNER JOIN states t ON s.State_ID = t.State_ID
 WHERE t.state = 'Maharashtra';


 -- For Maharashtra take total no of seats , total no of candidates , total number of parties , total votes including evm 
 -- and postal  and breakdown of evm and postal votes
 SELECT 
COUNT(DISTINCT s.constituency_id) AS Total_seats,
COUNT (DISTINCT t.candidate) AS Total_candidates,
COUNT(DISTINCT r.party) AS Total_parties,
SUM(t.evm_votes+t.postal_votes) AS Total_votes,
SUM(t.EVM_Votes) AS Total_EVM_Votes,
SUM(t.Postal_Votes) AS Total_Postal_Votes,
st.state  as State_name
FROM constituencywise_results s
JOIN constituencywise_details t ON s.constituency_id = t.constituency_id
JOIN partywise_results r ON s.party_id = r.party_id 
JOIN statewise_results sr ON  s.parliament_constituency =sr.parliament_constituency
JOIN states st ON  sr.state_id = st.state_id 
WHERE st.state ='Maharashtra'
GROUP BY st.state;

