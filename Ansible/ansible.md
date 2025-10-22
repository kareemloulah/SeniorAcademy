# Automation with cms "configuration management system"
 examples : cloud , puppet , salt stack , chef
  ## Ansible lab setup:
    *minimal vms no GUI *1 cpu 1-2 G-ram 15G storage**
   - minimal:
    - 2 vms :
     - 1 manager
     - 1 host node 
   - recomended:
    - 3 vms :
     - 1 manager
     - 2 host nodes:
      - 1 redhat / centos
      - 1 ubuntu / debian
   - optinal:
    - +4 vms:
     - 1 manager 
     - 3 vms:
      - 1 redhat / centos
      - 1 ubuntu / debian
      - 2 for diff version ex: rh v.7 
   ## setup / config:
    - contorller / manager :
     - netwrok config 
     - ssh-key (pub, private)
     - add key to all managed hosts/nodes
     - DNS (hosts file) config
     - install ansible
    - managed hosts / nodes :
     - network cofig 
     - ssh service installed 
     - python 3 is instlled
     - sudo / admin user 
   ## ansible usage config:
     - mian config file:
      - ansible.cfg
     
      [defaults]
     remote_user=<user_name_on_hosts>
     inventory=</path/to/inventroy>
     forks=5
     host_key_checking=false



     [privilage_escalation]
     become=true
     become_method=sudo
     become_user=root
     become_ask_pass=false

     
      
     - inventory:
      - can be named but has to be mentioned in ansible.cfg 
      - contains hosts 
     - can be grouped 
     - written in INI
    
         [group 1]
      name/ip
      [group2]
      name/ip 
     
   ## manage hosts using ansible
    - ad-hok "cli"
     - ansibel <groups_name/s or host_name/s> <-m> <module_name> <-a> "cmd"  
    - playbook "yaml"
     -