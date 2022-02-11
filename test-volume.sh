brew install --cask multipass
sleep 15s
multipass launch --disk 15G --mem 4G --cpus 2 --name primary
multipass mount $HOME primary:/home/ubuntu

echo "this is a file just for testing\n" > ~/one.txt
mkdir -p ~/test
echo "this is another file just for testing\n" > ~/test/two.txt

if [[ $( multipass exec -v primary -- cat /home/ubuntu/one.txt ) == "this is a file just for testing\n" ]]
then
echo "cool!"
else
exit 1
fi
if [[ $( multipass exec -v primary -- cat /home/ubuntu/test/two.txt ) == "this is another file just for testing\n" ]]
then
echo "perfect!"
else
exit 1
fi
